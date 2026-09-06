#include <WiFi.h>
#include <esp_now.h>
#include <esp_mac.h>
#include <esp_arduino_version.h>
#include <HTTPClient.h>
#include <stddef.h>
#include <ctype.h>

static const char *NODE_NAME = "B";
static const char *WIFI_SSID = "iPhone12112";
static const char *WIFI_PASSWORD = "92exploree";
static const char *FIREBASE_API_KEY = "AIzaSyCBn0-aVYZDR--smvT_CC1ayaBhxIwRiH4";
static const char *FIREBASE_PROJECT_ID = "rssi-test-df593";
static const uint8_t ADMIN_TEST_SWITCH_PIN = 27;  // INPUT_PULLUP: switch ON = GPIO27 connected to GND.

static const uint8_t PEER_MACS[][6] = {
  {0xB0, 0xCB, 0xD8, 0xC7, 0xF1, 0x80},
  {0x58, 0x2A, 0xBD, 0x70, 0x8B, 0xFC}
};
static const uint8_t PEER_COUNT = sizeof(PEER_MACS) / sizeof(PEER_MACS[0]);

static const char *BEACON_IDS[13] = {
  "B01", "B02", "B03", "B04", "B05", "B06",
  "B07", "B08", "B09", "B10", "B11", "B12", "H"
};
static const uint8_t BEACON_COUNT = sizeof(BEACON_IDS) / sizeof(BEACON_IDS[0]);
static const uint16_t ALL_BEACON_FLAGS = static_cast<uint16_t>((1U << BEACON_COUNT) - 1U);

static const uint32_t PACKET_MAGIC = 0x42434E44UL;
static const uint8_t PROTOCOL_VERSION = 3;
static const uint8_t PKT_FIRE = 1;
static const uint8_t PKT_MAIN_ACK = 2;
static const uint8_t PKT_ADMIN_TEST_FIRE = 5;
static const uint8_t PKT_ADMIN_TEST_STOP = 6;
static const uint8_t MAX_HOPS = 10;
static const uint8_t MAX_EVENTS = 8;
static const uint8_t RX_QUEUE_SIZE = 12;
static const uint32_t ACK_SEND_DURATION_MS = 12000;
static const uint32_t EVENT_MEMORY_MS = 90000;
static const uint32_t ACK_SEND_INTERVAL_MS = 100;
static const uint32_t ADMIN_TEST_FIRE_INTERVAL_MS = 140;
static const uint32_t ADMIN_TEST_STOP_SEND_MS = 12000;
static const uint32_t WIFI_RETRY_INTERVAL_MS = 10000;
static const uint32_t FIREBASE_RETRY_INTERVAL_MS = 3000;
static const uint32_t FIREBASE_ADMIN_TEST_INTERVAL_MS = 2000;

struct MeshPacket {
  uint32_t magic;
  uint8_t version;
  uint8_t type;
  uint8_t originNode;
  uint16_t eventSeq;
  uint16_t fireFlags;
  uint8_t ttl;
  char guideSlot1;
  char guideSlot2;
  uint16_t crc;
};

struct AckEvent {
  bool used;
  uint8_t originNode;
  uint16_t eventSeq;
  uint16_t fireFlags;
  uint32_t ackUntilMs;
  uint32_t rememberUntilMs;
};

struct RxItem {
  uint8_t sourceMac[6];
  MeshPacket packet;
};

AckEvent events[MAX_EVENTS] = {};
RxItem rxQueue[RX_QUEUE_SIZE];
volatile uint8_t rxHead = 0;
volatile uint8_t rxTail = 0;
portMUX_TYPE rxMux = portMUX_INITIALIZER_UNLOCKED;

uint16_t latchedRealFireFlags = 0;
uint16_t firebaseDoneFlags = 0;
uint32_t lastAckSendMs = 0;
uint32_t lastAdminTestFireSendMs = 0;
uint32_t lastAdminTestStopSendMs = 0;
uint32_t adminTestStopUntilMs = 0;
uint32_t lastWifiRetryMs = 0;
uint32_t lastFirebaseTryMs = 0;
uint32_t lastAdminTestPollMs = 0;
uint8_t eventCursor = 0;
uint8_t peerCursor = 0;
uint8_t adminTestPeerCursor = 0;
uint8_t adminTestStopPeerCursor = 0;
bool espNowReady = false;
bool adminTestActive = false;
bool lastAdminTestSwitchOn = false;
bool adminTestSwitchSynced = false;
bool adminTestSwitchSyncedValue = false;
uint8_t adminTestOriginNode = 0;
uint16_t adminTestEventSeq = 0;
uint16_t adminTestFireFlags = 0;
uint16_t adminTestStopFlags = 0;
String adminTestBeaconId = "";

struct AdminTestDocument {
  bool isTest;
  bool testActive;
  String selectedBeaconId;
};

String formatMac(const uint8_t mac[6]) {
  char buffer[18];
  snprintf(buffer, sizeof(buffer), "%02X:%02X:%02X:%02X:%02X:%02X",
           mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
  return String(buffer);
}

uint16_t packetCrc(const MeshPacket &packet) {
  uint16_t crc = 0xA5A5;
  const uint8_t *bytes = reinterpret_cast<const uint8_t *>(&packet);
  for (size_t i = 0; i < offsetof(MeshPacket, crc); i++) {
    crc = static_cast<uint16_t>((crc << 5) | (crc >> 11));
    crc ^= bytes[i];
  }
  return crc;
}

bool validPacket(const uint8_t *data, int len, MeshPacket &out) {
  if (len != sizeof(MeshPacket)) return false;
  memcpy(&out, data, sizeof(MeshPacket));
  if (out.magic != PACKET_MAGIC || out.version != PROTOCOL_VERSION) return false;
  return out.crc == packetCrc(out);
}

bool isKnownPeer(const uint8_t mac[6]) {
  if (mac == nullptr) return false;
  for (uint8_t i = 0; i < PEER_COUNT; i++) {
    if (memcmp(mac, PEER_MACS[i], 6) == 0) return true;
  }
  return false;
}

void enqueuePacket(const uint8_t sourceMac[6], const MeshPacket &packet) {
  portENTER_CRITICAL(&rxMux);
  uint8_t next = static_cast<uint8_t>((rxHead + 1) % RX_QUEUE_SIZE);
  if (next != rxTail) {
    memcpy(rxQueue[rxHead].sourceMac, sourceMac, 6);
    rxQueue[rxHead].packet = packet;
    rxHead = next;
  }
  portEXIT_CRITICAL(&rxMux);
}

bool dequeuePacket(RxItem &item) {
  bool available = false;
  portENTER_CRITICAL(&rxMux);
  if (rxTail != rxHead) {
    item = rxQueue[rxTail];
    rxTail = static_cast<uint8_t>((rxTail + 1) % RX_QUEUE_SIZE);
    available = true;
  }
  portEXIT_CRITICAL(&rxMux);
  return available;
}

void receivePacket(const uint8_t sourceMac[6], const uint8_t *data, int len) {
  if (!isKnownPeer(sourceMac)) return;
  MeshPacket packet;
  if (!validPacket(data, len, packet) || packet.type != PKT_FIRE ||
      packet.fireFlags == 0) return;
  enqueuePacket(sourceMac, packet);
}

#if ESP_ARDUINO_VERSION_MAJOR >= 3
void onDataRecv(const esp_now_recv_info_t *info, const uint8_t *data, int len) {
  receivePacket(info == nullptr ? nullptr : info->src_addr, data, len);
}
#else
void onDataRecv(const uint8_t *mac, const uint8_t *data, int len) {
  receivePacket(mac, data, len);
}
#endif

AckEvent *findEvent(uint8_t originNode, uint16_t eventSeq) {
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (events[i].used && events[i].originNode == originNode &&
        events[i].eventSeq == eventSeq) return &events[i];
  }
  return nullptr;
}

AckEvent *allocateEvent(uint32_t now) {
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (!events[i].used || static_cast<int32_t>(now - events[i].rememberUntilMs) >= 0) {
      events[i] = {};
      events[i].used = true;
      return &events[i];
    }
  }
  return nullptr;
}

MeshPacket makeAckPacket(const AckEvent &event);
MeshPacket makePacket(uint8_t type, uint8_t originNode, uint16_t eventSeq, uint16_t fireFlags);
void sendAck(const uint8_t mac[6], MeshPacket packet);
void sendPacket(const uint8_t mac[6], MeshPacket packet, const char *label);

void acceptFire(const uint8_t sourceMac[6], const MeshPacket &packet) {
  uint32_t now = millis();
  AckEvent *event = findEvent(packet.originNode, packet.eventSeq);
  bool isNew = event == nullptr;
  if (event == nullptr) {
    event = allocateEvent(now);
    if (event == nullptr) return;
    event->originNode = packet.originNode;
    event->eventSeq = packet.eventSeq;
    event->fireFlags = packet.fireFlags;
    event->ackUntilMs = now + ACK_SEND_DURATION_MS;
    event->rememberUntilMs = now + EVENT_MEMORY_MS;
    Serial.printf("[B] NEW REAL FIRE event=%u:%u flags=0x%04X; MAIN ACK started\n",
                  packet.originNode, packet.eventSeq, packet.fireFlags);
  } else {
    event->fireFlags |= packet.fireFlags;
  }
  latchedRealFireFlags |= packet.fireFlags;
  if (isNew) sendAck(sourceMac, makeAckPacket(*event));
}

MeshPacket makeAckPacket(const AckEvent &event) {
  return makePacket(PKT_MAIN_ACK, event.originNode, event.eventSeq, event.fireFlags);
}

MeshPacket makePacket(uint8_t type, uint8_t originNode, uint16_t eventSeq, uint16_t fireFlags) {
  MeshPacket packet = {};
  packet.magic = PACKET_MAGIC;
  packet.version = PROTOCOL_VERSION;
  packet.type = type;
  packet.originNode = originNode;
  packet.eventSeq = eventSeq;
  packet.fireFlags = fireFlags;
  packet.ttl = MAX_HOPS;
  packet.guideSlot1 = type == PKT_ADMIN_TEST_STOP ? 'S' : 'T';
  packet.guideSlot2 = type == PKT_FIRE ? 'R' : 'S';
  packet.crc = packetCrc(packet);
  return packet;
}

void sendAck(const uint8_t mac[6], MeshPacket packet) {
  sendPacket(mac, packet, "ACK");
}

void sendPacket(const uint8_t mac[6], MeshPacket packet, const char *label) {
  esp_err_t result = esp_now_send(
    mac, reinterpret_cast<const uint8_t *>(&packet), sizeof(packet));
  Serial.printf("[B] %s type=%u event=%u:%u flags=0x%04X to=%s %s\n",
                label, packet.type, packet.originNode, packet.eventSeq,
                packet.fireFlags, formatMac(mac).c_str(),
                result == ESP_OK ? "OK" : "FAIL");
}

void processReceivedPackets() {
  RxItem item;
  while (dequeuePacket(item)) acceptFire(item.sourceMac, item.packet);
}

void runAckTransmitter(uint32_t now) {
  if (now - lastAckSendMs < ACK_SEND_INTERVAL_MS) return;
  for (uint8_t offset = 0; offset < MAX_EVENTS; offset++) {
    uint8_t index = static_cast<uint8_t>((eventCursor + offset) % MAX_EVENTS);
    if (events[index].used &&
        static_cast<int32_t>(now - events[index].ackUntilMs) < 0) {
      sendAck(PEER_MACS[peerCursor], makeAckPacket(events[index]));
      peerCursor = static_cast<uint8_t>((peerCursor + 1) % PEER_COUNT);
      eventCursor = static_cast<uint8_t>((index + 1) % MAX_EVENTS);
      lastAckSendMs = now;
      return;
    }
  }
}

void runAdminTestFireTransmitter(uint32_t now) {
  if (!adminTestActive || adminTestFireFlags == 0) return;
  if (now - lastAdminTestFireSendMs < ADMIN_TEST_FIRE_INTERVAL_MS) return;
  sendPacket(PEER_MACS[adminTestPeerCursor],
             makePacket(PKT_ADMIN_TEST_FIRE, adminTestOriginNode, adminTestEventSeq,
                        adminTestFireFlags),
             "ADMIN TEST FIRE");
  adminTestPeerCursor = static_cast<uint8_t>((adminTestPeerCursor + 1) % PEER_COUNT);
  lastAdminTestFireSendMs = now;
}

void runAdminTestStopTransmitter(uint32_t now) {
  if (static_cast<int32_t>(now - adminTestStopUntilMs) >= 0) return;
  if (now - lastAdminTestStopSendMs < ADMIN_TEST_FIRE_INTERVAL_MS) return;
  sendPacket(PEER_MACS[adminTestStopPeerCursor],
             makePacket(PKT_ADMIN_TEST_STOP, adminTestOriginNode, adminTestEventSeq,
                        adminTestStopFlags),
             "ADMIN TEST STOP");
  adminTestStopPeerCursor = static_cast<uint8_t>((adminTestStopPeerCursor + 1) % PEER_COUNT);
  lastAdminTestStopSendMs = now;
}

void expireEvents(uint32_t now) {
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (events[i].used && static_cast<int32_t>(now - events[i].rememberUntilMs) >= 0) {
      events[i] = {};
    }
  }
}

void connectWifiIfNeeded() {
  uint32_t now = millis();
  if (WiFi.status() == WL_CONNECTED ||
      now - lastWifiRetryMs < WIFI_RETRY_INTERVAL_MS) return;
  lastWifiRetryMs = now;
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

bool updateFirestoreOnFire(const char *beaconId) {
  if (WiFi.status() != WL_CONNECTED) return false;
  HTTPClient http;
  String url = "https://firestore.googleapis.com/v1/projects/";
  url += FIREBASE_PROJECT_ID;
  url += "/databases/(default)/documents/beacons/";
  url += beaconId;
  url += "?updateMask.fieldPaths=onFire&key=";
  url += FIREBASE_API_KEY;
  http.begin(url);
  http.addHeader("Content-Type", "application/json");
  int code = http.PATCH("{\"fields\":{\"onFire\":{\"booleanValue\":true}}}");
  String response = http.getString();
  http.end();
  if (code == 200) {
    Serial.printf("[B] Firestore %s onFire=true OK\n", beaconId);
    return true;
  }
  Serial.printf("[B] Firestore %s failed HTTP=%d %s\n",
                beaconId, code, response.c_str());
  return false;
}

bool updateFirestoreAdminTestSwitch(bool isTest, bool resetTestActive) {
  if (WiFi.status() != WL_CONNECTED) return false;
  HTTPClient http;
  String url = "https://firestore.googleapis.com/v1/projects/";
  url += FIREBASE_PROJECT_ID;
  url += "/databases/(default)/documents/admin/test";
  url += "?updateMask.fieldPaths=isTest";
  if (resetTestActive) url += "&updateMask.fieldPaths=testActive";
  url += "&key=";
  url += FIREBASE_API_KEY;

  String body = "{\"fields\":{\"isTest\":{\"booleanValue\":";
  body += isTest ? "true" : "false";
  body += "}";
  if (resetTestActive) {
    body += ",\"testActive\":{\"booleanValue\":false}";
  }
  body += "}}";

  http.begin(url);
  http.addHeader("Content-Type", "application/json");
  int code = http.PATCH(body);
  String response = http.getString();
  http.end();
  if (code == 200) {
    Serial.printf("[B] Firestore admin/test isTest=%s%s OK\n",
                  isTest ? "true" : "false",
                  resetTestActive ? " testActive=false" : "");
    return true;
  }
  Serial.printf("[B] Firestore admin/test switch sync failed HTTP=%d %s\n",
                code, response.c_str());
  return false;
}

bool extractFirestoreValue(const String &json, const char *fieldName,
                           const char *valueType, String &out) {
  String fieldMarker = "\"";
  fieldMarker += fieldName;
  fieldMarker += "\"";
  int fieldPos = json.indexOf(fieldMarker);
  if (fieldPos < 0) return false;

  String typeMarker = "\"";
  typeMarker += valueType;
  typeMarker += "\"";
  int typePos = json.indexOf(typeMarker, fieldPos);
  if (typePos < 0 || typePos - fieldPos > 420) return false;

  int colon = json.indexOf(':', typePos);
  if (colon < 0) return false;
  int valueStart = colon + 1;
  while (valueStart < json.length() && isspace(json[valueStart])) valueStart++;
  if (valueStart >= json.length()) return false;

  if (json[valueStart] == '"') {
    int valueEnd = json.indexOf('"', valueStart + 1);
    if (valueEnd < 0) return false;
    out = json.substring(valueStart + 1, valueEnd);
  } else {
    int valueEnd = valueStart;
    while (valueEnd < json.length() && json[valueEnd] != ',' &&
           json[valueEnd] != '}' && !isspace(json[valueEnd])) {
      valueEnd++;
    }
    out = json.substring(valueStart, valueEnd);
  }
  out.trim();
  return out.length() > 0;
}

bool parseAdminTestDocument(const String &json, AdminTestDocument &doc) {
  String value;
  doc.isTest = false;
  doc.testActive = false;
  doc.selectedBeaconId = "";
  if (extractFirestoreValue(json, "isTest", "booleanValue", value) ||
      extractFirestoreValue(json, "isTest", "integerValue", value)) {
    value.toLowerCase();
    doc.isTest = value == "true" || value == "1";
  }

  value = "";
  if (extractFirestoreValue(json, "testActive", "booleanValue", value) ||
      extractFirestoreValue(json, "test_active", "booleanValue", value) ||
      extractFirestoreValue(json, "testActive", "integerValue", value)) {
    value.toLowerCase();
    doc.testActive = value == "true" || value == "1";
  }

  value = "";
  if (extractFirestoreValue(json, "selectedBeaconId", "stringValue", value) ||
      extractFirestoreValue(json, "selected_beacon_id", "stringValue", value) ||
      extractFirestoreValue(json, "fireBeaconId", "stringValue", value)) {
    value.trim();
    doc.selectedBeaconId = value;
  }
  return true;
}

bool fetchAdminTestDocument(AdminTestDocument &doc) {
  if (WiFi.status() != WL_CONNECTED) return false;
  HTTPClient http;
  String url = "https://firestore.googleapis.com/v1/projects/";
  url += FIREBASE_PROJECT_ID;
  url += "/databases/(default)/documents/admin/test?key=";
  url += FIREBASE_API_KEY;
  http.begin(url);
  int code = http.GET();
  String response = http.getString();
  http.end();
  if (code == 200 && parseAdminTestDocument(response, doc)) {
    Serial.printf("[B] Admin test doc isTest=%s testActive=%s selected=%s\n",
                  doc.isTest ? "true" : "false",
                  doc.testActive ? "true" : "false",
                  doc.selectedBeaconId.c_str());
    return true;
  }
  Serial.printf("[B] Admin test doc read failed HTTP=%d %s\n",
                code, response.c_str());
  return false;
}

bool beaconIdToFireFlags(const String &beaconId, uint16_t &fireFlags,
                         String &label) {
  String normalized = beaconId;
  normalized.trim();
  normalized.toUpperCase();
  if (normalized == "H708") normalized = "H";

  fireFlags = 0;
  label = "";
  if (normalized.length() == 0) return false;

  for (uint8_t i = 0; i < BEACON_COUNT; i++) {
    if (normalized == BEACON_IDS[i]) {
      fireFlags = static_cast<uint16_t>(1U << i);
      label = BEACON_IDS[i];
      return true;
    }
  }
  return false;
}

void stopAdminTest(uint32_t now) {
  if (!adminTestActive) return;
  AckEvent *event = findEvent(adminTestOriginNode, adminTestEventSeq);
  if (event != nullptr) event->ackUntilMs = now;
  Serial.printf("[B] Admin test stopped beacon=%s; stop all BLE flags=0x%04X\n",
                adminTestBeaconId.c_str(), ALL_BEACON_FLAGS);
  adminTestStopFlags = ALL_BEACON_FLAGS;
  adminTestStopUntilMs = now + ADMIN_TEST_STOP_SEND_MS;
  adminTestStopPeerCursor = 0;
  lastAdminTestStopSendMs = 0;
  adminTestActive = false;
}

void startOrRefreshAdminTest(uint32_t now, uint16_t fireFlags, String label) {
  if (fireFlags == 0) {
    stopAdminTest(now);
    return;
  }

  uint8_t originNode = 1;
  for (uint8_t i = 0; i < BEACON_COUNT; i++) {
    if (fireFlags & static_cast<uint16_t>(1U << i)) {
      originNode = static_cast<uint8_t>(i + 1);
      break;
    }
  }

  bool newTest = !adminTestActive || adminTestOriginNode != originNode ||
                 adminTestFireFlags != fireFlags || adminTestBeaconId != label;
  if (newTest) {
    adminTestEventSeq = static_cast<uint16_t>((millis() & 0xFFFF) ^ 0xA55A);
    if (adminTestEventSeq == 0) adminTestEventSeq = 1;
    adminTestPeerCursor = 0;
    lastAdminTestFireSendMs = 0;
    adminTestStopUntilMs = now;
    adminTestStopFlags = 0;
    Serial.printf("[B] Admin test started beacon=%s event=%u:%u flags=0x%04X\n",
                  label.c_str(), originNode, adminTestEventSeq, fireFlags);
  }

  adminTestActive = true;
  adminTestOriginNode = originNode;
  adminTestFireFlags = fireFlags;
  adminTestBeaconId = label;

  AckEvent *event = findEvent(adminTestOriginNode, adminTestEventSeq);
  if (event == nullptr) {
    event = allocateEvent(now);
    if (event == nullptr) return;
  }
  event->originNode = adminTestOriginNode;
  event->eventSeq = adminTestEventSeq;
  event->fireFlags = adminTestFireFlags;
  event->ackUntilMs = now + ACK_SEND_DURATION_MS;
  event->rememberUntilMs = now + EVENT_MEMORY_MS;
}

bool isAdminTestSwitchOn() {
  return digitalRead(ADMIN_TEST_SWITCH_PIN) == LOW;
}

void processAdminTestMode() {
  uint32_t now = millis();
  bool switchOn = isAdminTestSwitchOn();
  if (switchOn != lastAdminTestSwitchOn) {
    Serial.printf("[B] Admin test switch %s\n", switchOn ? "ON" : "OFF");
    lastAdminTestSwitchOn = switchOn;
    adminTestSwitchSynced = false;
  }

  connectWifiIfNeeded();
  if (!adminTestSwitchSynced || adminTestSwitchSyncedValue != switchOn) {
    bool synced = updateFirestoreAdminTestSwitch(switchOn, !switchOn);
    if (synced) {
      adminTestSwitchSynced = true;
      adminTestSwitchSyncedValue = switchOn;
    }
  }

  if (!switchOn) {
    stopAdminTest(now);
    return;
  }

  if (now - lastAdminTestPollMs < FIREBASE_ADMIN_TEST_INTERVAL_MS) return;
  lastAdminTestPollMs = now;

  AdminTestDocument doc;
  if (!fetchAdminTestDocument(doc)) return;
  if (!doc.isTest || !doc.testActive || doc.selectedBeaconId.length() == 0) {
    stopAdminTest(now);
    return;
  }

  uint16_t fireFlags;
  String label = "";
  if (!beaconIdToFireFlags(doc.selectedBeaconId, fireFlags, label)) {
    Serial.printf("[B] Admin test invalid selectedBeaconId=%s\n",
                  doc.selectedBeaconId.c_str());
    stopAdminTest(now);
    return;
  }
  startOrRefreshAdminTest(now, fireFlags, label);
}

void processFirestoreUpdates() {
  if (latchedRealFireFlags == 0) return;
  connectWifiIfNeeded();
  uint32_t now = millis();
  if (now - lastFirebaseTryMs < FIREBASE_RETRY_INTERVAL_MS) return;
  lastFirebaseTryMs = now;
  for (uint8_t i = 0; i < BEACON_COUNT; i++) {
    uint16_t bit = static_cast<uint16_t>(1U << i);
    if ((latchedRealFireFlags & bit) && !(firebaseDoneFlags & bit) &&
        updateFirestoreOnFire(BEACON_IDS[i])) {
      firebaseDoneFlags |= bit;
    }
  }
}

void addPeer(const uint8_t mac[6]) {
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, mac, 6);
  peer.channel = 0;
  peer.encrypt = false;
  esp_err_t result = esp_now_add_peer(&peer);
  Serial.printf("[B] peer %s add=%s\n", formatMac(mac).c_str(),
                result == ESP_OK || result == ESP_ERR_ESPNOW_EXIST ? "OK" : "FAIL");
}

void initNetwork() {
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  uint32_t start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < 10000) {
    delay(250);
  }
  Serial.printf("[B] Wi-Fi status=%d channel=%d\n", WiFi.status(), WiFi.channel());
  if (esp_now_init() != ESP_OK) {
    Serial.println("[B] ESP-NOW init failed");
    return;
  }
  for (uint8_t i = 0; i < PEER_COUNT; i++) addPeer(PEER_MACS[i]);
  esp_now_register_recv_cb(onDataRecv);
  espNowReady = true;
}

void printStaMac() {
  uint8_t mac[6] = {0};
  esp_read_mac(mac, ESP_MAC_WIFI_STA);
  Serial.printf("[B] STA MAC=%s\n", formatMac(mac).c_str());
}

void setup() {
  Serial.begin(115200);
  pinMode(ADMIN_TEST_SWITCH_PIN, INPUT_PULLUP);
  lastAdminTestSwitchOn = isAdminTestSwitchOn();
  adminTestSwitchSynced = false;
  initNetwork();
  printStaMac();
  Serial.printf("[B] ready ESP-NOW=%s peers=B02,B03 adminSwitchPin=%u state=%s\n",
                espNowReady ? "OK" : "FAIL", ADMIN_TEST_SWITCH_PIN,
                lastAdminTestSwitchOn ? "ON" : "OFF");
}

void loop() {
  uint32_t now = millis();
  processReceivedPackets();
  processAdminTestMode();
  runAdminTestFireTransmitter(now);
  runAdminTestStopTransmitter(now);
  runAckTransmitter(now);
  expireEvents(now);
  processFirestoreUpdates();
  delay(3);
}
