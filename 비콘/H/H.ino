#include <WiFi.h>
#include <esp_now.h>
#include <esp_mac.h>
#include <esp_wifi.h>
#include <esp_arduino_version.h>
#include <esp_system.h>
#include <BLEDevice.h>
#include <Adafruit_NeoPixel.h>
#include "esp_bt.h"
#include <stddef.h>

static const char *NODE_NAME = "H";
static const uint8_t NODE_INDEX = 13;
static const uint8_t TRIGGER_PIN = 0;
static const uint8_t LED_PIN = 4;
static const uint8_t LED_COUNT = 25;
static const uint8_t LED_BRIGHTNESS = 50;
static const uint8_t MESH_CHANNEL = 13;
static const bool HAS_MAIN_PEER = false;
static const uint8_t MAC_MAIN[6] = {0x20, 0x50, 0x0D, 0xD0, 0x80, 0x5C};
static const uint8_t PEER_MACS[][6] = {
  {0x58, 0x2A, 0xBD, 0x70, 0x8D, 0xCC}
};
static const uint8_t PEER_COUNT = sizeof(PEER_MACS) / sizeof(PEER_MACS[0]);

static const char *BEACON_UUID = "f7826da6-4fa2-4e98-8024-bc5b71e0893e";
static const uint16_t THIS_FIRE_BIT = 1U << (NODE_INDEX - 1);
static const uint16_t BLE_BEACON_MINOR = 99 + NODE_INDEX;
static const uint16_t BLE_ADV_INTERVAL_50MS = 0x50;

static const uint16_t BIT_B01 = 1U << 0;
static const uint16_t BIT_B02 = 1U << 1;
static const uint16_t BIT_B03 = 1U << 2;
static const uint16_t BIT_B04 = 1U << 3;
static const uint16_t BIT_B05 = 1U << 4;
static const uint16_t BIT_B06 = 1U << 5;
static const uint16_t BIT_B07 = 1U << 6;
static const uint16_t BIT_B08 = 1U << 7;
static const uint16_t BIT_B09 = 1U << 8;
static const uint16_t BIT_B10 = 1U << 9;
static const uint16_t BIT_B11 = 1U << 10;
static const uint16_t BIT_B12 = 1U << 11;
static const uint16_t BIT_H = 1U << 12;

static const uint32_t PACKET_MAGIC = 0x42434E44UL;
static const uint8_t PROTOCOL_VERSION = 3;
static const uint32_t FIRE_DURATION_MS = 30000;
static const uint32_t ACK_RELAY_DURATION_MS = 10000;
static const uint32_t EVENT_MEMORY_MS = 90000;
static const uint32_t MESH_SEND_INTERVAL_MS = 140;
static const uint32_t ADMIN_TEST_STOP_RELAY_MS = 3500;
static const uint32_t MAIN_PROBE_INTERVAL_MS = 220;
static const uint32_t MAIN_LISTEN_MS = 60;
static const uint32_t BUTTON_DEBOUNCE_MS = 80;
static const uint8_t MAX_EVENTS = 8;
static const uint8_t RX_QUEUE_SIZE = 12;
static const uint8_t MAX_HOPS = 10;

enum PacketType : uint8_t {
  PKT_FIRE = 1,
  PKT_MAIN_ACK = 2,
  PKT_BLE_START = 3,
  PKT_GUIDE = 4,
  PKT_ADMIN_TEST_FIRE = 5,
  PKT_ADMIN_TEST_STOP = 6
};

enum GuideDirection : uint8_t {
  DIR_NONE = 0,
  DIR_UP,
  DIR_DOWN,
  DIR_WEST,
  DIR_EAST,
  DIR_X
};

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

struct EventState {
  bool used;
  bool acknowledged;
  bool adminTest;
  uint8_t originNode;
  uint16_t eventSeq;
  uint16_t fireFlags;
  uint8_t fireTtl;
  uint8_t ackTtl;
  uint32_t fireUntilMs;
  uint32_t ackUntilMs;
  uint32_t rememberUntilMs;
};

struct RxItem {
  uint8_t sourceMac[6];
  MeshPacket packet;
};

BLEAdvertising *advertising = nullptr;
Adafruit_NeoPixel pixels(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);
bool bleAdvertisingActive = false;
bool espNowReady = false;
EventState events[MAX_EVENTS] = {};
RxItem rxQueue[RX_QUEUE_SIZE];
volatile uint8_t rxHead = 0;
volatile uint8_t rxTail = 0;
portMUX_TYPE rxMux = portMUX_INITIALIZER_UNLOCKED;

uint16_t realFireFlagsLatched = 0;
uint16_t adminTestFireFlags = 0;
uint16_t localEventSeq = 1;
bool rawButtonPressed = false;
bool stableButtonPressed = false;
uint32_t lastButtonEdgeMs = 0;
uint32_t lastMeshSendMs = 0;
uint32_t lastMainProbeMs = 0;
uint32_t mainListenStartedMs = 0;
uint32_t adminTestStopRelayUntilMs = 0;
uint8_t eventCursor = 0;
uint8_t mainEventCursor = 0;
uint8_t peerCursor = 0;
uint8_t mainScanCursor = 0;
uint8_t adminTestStopPeerCursor = 0;
uint8_t learnedMainChannel = 0;
uint8_t currentChannel = MESH_CHANNEL;
bool listeningForMain = false;
GuideDirection currentDisplayedDirection = DIR_NONE;
MeshPacket adminTestStopRelayPacket = {};

static const uint8_t MAIN_SCAN_ORDER[13] = {
  1, 6, 11, 2, 3, 4, 5, 7, 8, 9, 10, 12, 13
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

void setHardwareChannel(uint8_t channel) {
  if (channel < 1 || channel > 13 || channel == currentChannel) return;
  esp_wifi_set_promiscuous(true);
  esp_wifi_set_channel(channel, WIFI_SECOND_CHAN_NONE);
  esp_wifi_set_promiscuous(false);
  currentChannel = channel;
}

bool sameEvent(const EventState &event, uint8_t originNode, uint16_t eventSeq, bool adminTest) {
  return event.used && event.originNode == originNode && event.eventSeq == eventSeq &&
         event.adminTest == adminTest;
}

EventState *findEvent(uint8_t originNode, uint16_t eventSeq, bool adminTest) {
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (sameEvent(events[i], originNode, eventSeq, adminTest)) return &events[i];
  }
  return nullptr;
}

EventState *allocateEvent(uint32_t now) {
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (!events[i].used || static_cast<int32_t>(now - events[i].rememberUntilMs) >= 0) {
      events[i] = {};
      events[i].used = true;
      return &events[i];
    }
  }
  return nullptr;
}

bool fireIsActive(const EventState &event, uint32_t now) {
  return event.used && !event.adminTest && !event.acknowledged &&
         static_cast<int32_t>(now - event.fireUntilMs) < 0;
}

bool ackIsActive(const EventState &event, uint32_t now) {
  return event.used && !event.adminTest && event.acknowledged &&
         static_cast<int32_t>(now - event.ackUntilMs) < 0;
}

bool anyFireActive(uint32_t now) {
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (fireIsActive(events[i], now)) return true;
  }
  return false;
}

bool isMeshPeer(const uint8_t mac[6]) {
  if (mac == nullptr) return false;
  for (uint8_t i = 0; i < PEER_COUNT; i++) {
    if (memcmp(mac, PEER_MACS[i], 6) == 0) return true;
  }
  return false;
}

void expireEvents(uint32_t now) {
  bool outputsChanged = false;
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (events[i].used && events[i].adminTest &&
        static_cast<int32_t>(now - events[i].fireUntilMs) >= 0) {
      adminTestFireFlags &= static_cast<uint16_t>(~events[i].fireFlags);
      events[i] = {};
      outputsChanged = true;
      continue;
    }
    if (events[i].used && static_cast<int32_t>(now - events[i].rememberUntilMs) >= 0) {
      events[i] = {};
    }
  }
  if (outputsChanged) refreshOutputs();
}

int hexValue(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  return -1;
}

bool uuidToBytes(const char *uuid, uint8_t out[16]) {
  uint8_t index = 0;
  int highNibble = -1;
  for (const char *p = uuid; *p != '\0'; p++) {
    if (*p == '-') continue;
    int value = hexValue(*p);
    if (value < 0) return false;
    if (highNibble < 0) {
      highNibble = value;
    } else {
      if (index >= 16) return false;
      out[index++] = static_cast<uint8_t>((highNibble << 4) | value);
      highNibble = -1;
    }
  }
  return index == 16 && highNibble < 0;
}

String makeIBeaconData() {
  uint8_t uuidBytes[16] = {0};
  uuidToBytes(BEACON_UUID, uuidBytes);
  uint8_t data[25] = {0x4C, 0x00, 0x02, 0x15};
  memcpy(data + 4, uuidBytes, 16);
  data[20] = 0x00;
  data[21] = 0x01;
  data[22] = static_cast<uint8_t>(BLE_BEACON_MINOR >> 8);
  data[23] = static_cast<uint8_t>(BLE_BEACON_MINOR & 0xFF);
  data[24] = 0xC5;
  return String(reinterpret_cast<const char *>(data), sizeof(data));
}

void startBleAdvertising() {
  if (bleAdvertisingActive) return;
  BLEDevice::init(NODE_NAME);
  advertising = BLEDevice::getAdvertising();
  BLEAdvertisementData advData;
  advData.setFlags(0x1A);
  advData.setManufacturerData(makeIBeaconData());
  advertising->setAdvertisementData(advData);
  BLEAdvertisementData scanData;
  scanData.setName(NODE_NAME);
  advertising->setScanResponseData(scanData);
  advertising->setMinInterval(BLE_ADV_INTERVAL_50MS);
  advertising->setMaxInterval(BLE_ADV_INTERVAL_50MS);
  esp_ble_tx_power_set(ESP_BLE_PWR_TYPE_DEFAULT, ESP_PWR_LVL_P1);
  esp_ble_tx_power_set(ESP_BLE_PWR_TYPE_ADV, ESP_PWR_LVL_P1);
  advertising->start();
  bleAdvertisingActive = true;
  Serial.printf("[%s] BLE advertising started\n", NODE_NAME);
}

void stopBleAdvertising() {
  if (!bleAdvertisingActive) return;
  if (advertising != nullptr) advertising->stop();
  bleAdvertisingActive = false;
  Serial.printf("[%s] BLE advertising stopped\n", NODE_NAME);
}

void clearGuideLed() {
  pixels.clear();
  pixels.show();
  currentDisplayedDirection = DIR_NONE;
}

void lightLedNumbers(const uint8_t *numbers, uint8_t count, uint32_t color) {
  pixels.clear();
  for (uint8_t i = 0; i < count; i++) {
    uint8_t ledNumber = numbers[i];
    if (ledNumber >= 1 && ledNumber <= LED_COUNT) {
      pixels.setPixelColor(ledNumber - 1, color);
    }
  }
  pixels.show();
}

void showGuideLed(GuideDirection direction) {
  if (direction == currentDisplayedDirection) return;
  static const uint8_t UP_LEDS[] = {3, 8, 11, 13, 15, 17, 18, 19, 23};
  static const uint8_t DOWN_LEDS[] = {3, 7, 8, 9, 11, 13, 15, 18, 23};
  static const uint8_t WEST_LEDS[] = {3, 7, 11, 12, 13, 14, 15, 17, 23};
  static const uint8_t EAST_LEDS[] = {3, 9, 11, 12, 13, 14, 15, 19, 23};
  static const uint8_t X_LEDS[] = {1, 5, 7, 9, 13, 17, 19, 21, 25};
  uint32_t color = pixels.Color(255, 0, 0);

  switch (direction) {
    case DIR_UP:
      lightLedNumbers(UP_LEDS, sizeof(UP_LEDS), color);
      break;
    case DIR_DOWN:
      lightLedNumbers(DOWN_LEDS, sizeof(DOWN_LEDS), color);
      break;
    case DIR_WEST:
      lightLedNumbers(WEST_LEDS, sizeof(WEST_LEDS), color);
      break;
    case DIR_EAST:
      lightLedNumbers(EAST_LEDS, sizeof(EAST_LEDS), color);
      break;
    case DIR_X:
      lightLedNumbers(X_LEDS, sizeof(X_LEDS), color);
      break;
    default:
      clearGuideLed();
      return;
  }
  currentDisplayedDirection = direction;
  Serial.printf("[%s] guide LED direction=%u\n", NODE_NAME, direction);
}

GuideDirection directionForFlags(uint16_t flags) {
  if (flags & BIT_H) return DIR_X;
  if (flags & (BIT_B01 | BIT_B02 | BIT_B03 | BIT_B04 | BIT_B05 | BIT_B06 |
               BIT_B07 | BIT_B08 | BIT_B09 | BIT_B10 | BIT_B11 | BIT_B12)) {
    return DIR_EAST;
  }
  return DIR_NONE;
}

void refreshOutputs() {
  uint16_t displayFlags = realFireFlagsLatched != 0 ? realFireFlagsLatched : adminTestFireFlags;
  if (displayFlags != 0) {
    startBleAdvertising();
    showGuideLed(directionForFlags(displayFlags));
  } else {
    clearGuideLed();
    stopBleAdvertising();
  }
}

MeshPacket makeEventPacket(const EventState &event, PacketType type) {
  MeshPacket packet = {};
  packet.magic = PACKET_MAGIC;
  packet.version = PROTOCOL_VERSION;
  packet.type = type;
  packet.originNode = event.originNode;
  packet.eventSeq = event.eventSeq;
  packet.fireFlags = event.fireFlags;
  packet.ttl = type == PKT_MAIN_ACK ? event.ackTtl : event.fireTtl;
  packet.guideSlot1 = event.adminTest ? 'T' : 'R';
  packet.guideSlot2 = 'R';
  packet.crc = packetCrc(packet);
  return packet;
}

void sendPacketTo(const uint8_t targetMac[6], MeshPacket packet) {
  if (packet.ttl == 0) return;
  packet.crc = packetCrc(packet);
  esp_err_t result = esp_now_send(
    targetMac, reinterpret_cast<const uint8_t *>(&packet), sizeof(packet));
  Serial.printf("[%s] TX type=%u event=%u:%u flags=0x%04X ttl=%u to=%s %s\n",
                NODE_NAME, packet.type, packet.originNode, packet.eventSeq,
                packet.fireFlags, packet.ttl, formatMac(targetMac).c_str(),
                result == ESP_OK ? "OK" : "FAIL");
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
  if (sourceMac == nullptr) return;
  MeshPacket packet;
  if (!validPacket(data, len, packet)) return;
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

void beginFireEvent(uint8_t originNode, uint16_t eventSeq, uint16_t flags,
                    uint8_t incomingTtl, bool localEvent, bool adminTest) {
  uint32_t now = millis();
  EventState *event = findEvent(originNode, eventSeq, adminTest);
  if (event != nullptr) {
    event->fireFlags |= flags;
    if (adminTest) adminTestFireFlags |= flags;
    else realFireFlagsLatched |= flags;
    refreshOutputs();
    return;
  }

  event = allocateEvent(now);
  if (event == nullptr) {
    Serial.printf("[%s] event table full; dropped %u:%u\n", NODE_NAME, originNode, eventSeq);
    return;
  }

  event->adminTest = adminTest;
  event->originNode = originNode;
  event->eventSeq = eventSeq;
  event->fireFlags = flags;
  event->fireTtl = localEvent ? MAX_HOPS : (incomingTtl > 0 ? incomingTtl - 1 : 0);
  event->ackTtl = 0;
  event->fireUntilMs = now + FIRE_DURATION_MS;
  event->ackUntilMs = 0;
  event->rememberUntilMs = now + EVENT_MEMORY_MS;
  if (adminTest) adminTestFireFlags |= flags;
  else realFireFlagsLatched |= flags;
  refreshOutputs();
  Serial.printf("[%s] %s FIRE started event=%u:%u for relay window\n",
                NODE_NAME, adminTest ? "ADMIN TEST" : "REAL", originNode, eventSeq);
}

void acceptMainAck(const MeshPacket &packet) {
  uint32_t now = millis();
  if (findEvent(packet.originNode, packet.eventSeq, true) != nullptr) {
    Serial.printf("[%s] ADMIN TEST ACK ignored event=%u:%u flags=0x%04X\n",
                  NODE_NAME, packet.originNode, packet.eventSeq, packet.fireFlags);
    return;
  }

  EventState *event = findEvent(packet.originNode, packet.eventSeq, false);
  if (event == nullptr) {
    event = allocateEvent(now);
    if (event == nullptr) return;
    event->originNode = packet.originNode;
    event->eventSeq = packet.eventSeq;
    event->fireFlags = packet.fireFlags;
    event->adminTest = false;
  }
  realFireFlagsLatched |= packet.fireFlags;
  refreshOutputs();
  if (event->acknowledged) return;

  event->acknowledged = true;
  event->fireUntilMs = now;
  event->ackTtl = packet.ttl > 0 ? packet.ttl - 1 : 0;
  event->ackUntilMs = now + ACK_RELAY_DURATION_MS;
  event->rememberUntilMs = now + EVENT_MEMORY_MS;
  Serial.printf("[%s] MAIN ACK accepted event=%u:%u; FIRE relay stopped\n",
                NODE_NAME, packet.originNode, packet.eventSeq);
}

void acceptAdminTestStop(const MeshPacket &packet) {
  adminTestFireFlags = 0;
  realFireFlagsLatched &= static_cast<uint16_t>(~packet.fireFlags);
  for (uint8_t i = 0; i < MAX_EVENTS; i++) {
    if (events[i].used && events[i].adminTest) {
      events[i] = {};
    }
  }
  refreshOutputs();
  adminTestStopRelayPacket = packet;
  adminTestStopRelayUntilMs = millis() + ADMIN_TEST_STOP_RELAY_MS;
  adminTestStopPeerCursor = 0;
  Serial.printf("[%s] ADMIN TEST stopped flags=0x%04X\n", NODE_NAME, packet.fireFlags);
}

void processReceivedPackets() {
  RxItem item;
  while (dequeuePacket(item)) {
    MeshPacket &packet = item.packet;
    bool fromMain = HAS_MAIN_PEER && memcmp(item.sourceMac, MAC_MAIN, 6) == 0;

    if (fromMain) {
      if (packet.type == PKT_MAIN_ACK) {
        learnedMainChannel = currentChannel;
        acceptMainAck(packet);
      } else if (packet.type == PKT_ADMIN_TEST_FIRE && packet.fireFlags != 0) {
        learnedMainChannel = currentChannel;
        beginFireEvent(packet.originNode, packet.eventSeq, packet.fireFlags,
                       packet.ttl, false, true);
      } else if (packet.type == PKT_ADMIN_TEST_STOP) {
        learnedMainChannel = currentChannel;
        acceptAdminTestStop(packet);
      }
      continue;
    }

    if (!isMeshPeer(item.sourceMac)) continue;

    if (packet.type == PKT_FIRE && packet.fireFlags != 0 && packet.ttl > 0) {
      beginFireEvent(packet.originNode, packet.eventSeq, packet.fireFlags,
                     packet.ttl, false, false);
    } else if (packet.type == PKT_MAIN_ACK && packet.ttl > 0) {
      acceptMainAck(packet);
    } else if (packet.type == PKT_ADMIN_TEST_FIRE && packet.fireFlags != 0 && packet.ttl > 0) {
      beginFireEvent(packet.originNode, packet.eventSeq, packet.fireFlags,
                     packet.ttl, false, true);
    } else if (packet.type == PKT_ADMIN_TEST_STOP) {
      acceptAdminTestStop(packet);
    } else if (packet.type == PKT_BLE_START) {
      startBleAdvertising();
    }
  }
}

void pollFireButton() {
  uint32_t now = millis();
  bool pressed = digitalRead(TRIGGER_PIN) == LOW;
  if (pressed != rawButtonPressed) {
    rawButtonPressed = pressed;
    lastButtonEdgeMs = now;
  }
  if (pressed != stableButtonPressed && now - lastButtonEdgeMs >= BUTTON_DEBOUNCE_MS) {
    stableButtonPressed = pressed;
    if (stableButtonPressed) {
      uint16_t seq = localEventSeq++;
      if (localEventSeq == 0) localEventSeq = 1;
      beginFireEvent(NODE_INDEX, seq, THIS_FIRE_BIT, MAX_HOPS, true, false);
    }
  }
}

EventState *nextSendableEvent(uint32_t now) {
  for (uint8_t offset = 0; offset < MAX_EVENTS; offset++) {
    uint8_t index = static_cast<uint8_t>((eventCursor + offset) % MAX_EVENTS);
    if (fireIsActive(events[index], now) || ackIsActive(events[index], now) ||
        (events[index].used && events[index].adminTest &&
         static_cast<int32_t>(now - events[index].fireUntilMs) < 0)) {
      eventCursor = static_cast<uint8_t>((index + 1) % MAX_EVENTS);
      return &events[index];
    }
  }
  return nullptr;
}

EventState *nextUnackedFire(uint32_t now) {
  for (uint8_t offset = 0; offset < MAX_EVENTS; offset++) {
    uint8_t index = static_cast<uint8_t>((mainEventCursor + offset) % MAX_EVENTS);
    if (fireIsActive(events[index], now)) {
      mainEventCursor = static_cast<uint8_t>((index + 1) % MAX_EVENTS);
      return &events[index];
    }
  }
  return nullptr;
}

void runMeshRelay(uint32_t now) {
  if (listeningForMain || now - lastMeshSendMs < MESH_SEND_INTERVAL_MS) return;
  if (static_cast<int32_t>(now - adminTestStopRelayUntilMs) < 0 &&
      PEER_COUNT > 0) {
    setHardwareChannel(MESH_CHANNEL);
    MeshPacket packet = adminTestStopRelayPacket;
    packet.ttl = packet.ttl > 0 ? packet.ttl - 1 : MAX_HOPS;
    sendPacketTo(PEER_MACS[adminTestStopPeerCursor], packet);
    adminTestStopPeerCursor =
        static_cast<uint8_t>((adminTestStopPeerCursor + 1) % PEER_COUNT);
    lastMeshSendMs = now;
    return;
  }
  EventState *event = nextSendableEvent(now);
  if (event == nullptr || PEER_COUNT == 0) return;

  setHardwareChannel(MESH_CHANNEL);
  PacketType type = event->adminTest ? PKT_ADMIN_TEST_FIRE :
                    (event->acknowledged ? PKT_MAIN_ACK : PKT_FIRE);
  MeshPacket packet = makeEventPacket(*event, type);
  sendPacketTo(PEER_MACS[peerCursor], packet);
  peerCursor = static_cast<uint8_t>((peerCursor + 1) % PEER_COUNT);
  lastMeshSendMs = now;
}

uint8_t nextMainChannel() {
  if (learnedMainChannel >= 1 && learnedMainChannel <= 13) {
    uint8_t channel = learnedMainChannel;
    learnedMainChannel = 0;
    return channel;
  }
  uint8_t channel = MAIN_SCAN_ORDER[mainScanCursor];
  mainScanCursor = static_cast<uint8_t>((mainScanCursor + 1) % 13);
  return channel;
}

void runMainGateway(uint32_t now) {
  if (!HAS_MAIN_PEER) return;

  if (listeningForMain) {
    if (now - mainListenStartedMs >= MAIN_LISTEN_MS) {
      setHardwareChannel(MESH_CHANNEL);
      listeningForMain = false;
    }
    return;
  }

  if (!anyFireActive(now) || now - lastMainProbeMs < MAIN_PROBE_INTERVAL_MS) return;
  EventState *event = nextUnackedFire(now);
  if (event == nullptr) return;

  uint8_t channel = nextMainChannel();
  setHardwareChannel(channel);
  sendPacketTo(MAC_MAIN, makeEventPacket(*event, PKT_FIRE));
  listeningForMain = true;
  mainListenStartedMs = now;
  lastMainProbeMs = now;
}

void addPeer(const uint8_t mac[6], uint8_t channel) {
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, mac, 6);
  peer.channel = channel;
  peer.encrypt = false;
  esp_err_t result = esp_now_add_peer(&peer);
  Serial.printf("[%s] peer %s add=%s\n", NODE_NAME, formatMac(mac).c_str(),
                result == ESP_OK || result == ESP_ERR_ESPNOW_EXIST ? "OK" : "FAIL");
}

void initEspNow() {
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  esp_wifi_set_ps(WIFI_PS_NONE);
  WiFi.disconnect(false, false);
  delay(100);
  esp_wifi_set_max_tx_power(78);
  currentChannel = 0;
  setHardwareChannel(MESH_CHANNEL);

  if (esp_now_init() != ESP_OK) {
    Serial.printf("[%s] ESP-NOW init failed\n", NODE_NAME);
    return;
  }

  for (uint8_t i = 0; i < PEER_COUNT; i++) addPeer(PEER_MACS[i], 0);
  if (HAS_MAIN_PEER) addPeer(MAC_MAIN, 0);
  esp_now_register_recv_cb(onDataRecv);
  esp_wifi_config_espnow_rate(WIFI_IF_STA, WIFI_PHY_RATE_1M_L);
  espNowReady = true;
}

void printStaMac() {
  uint8_t mac[6] = {0};
  esp_read_mac(mac, ESP_MAC_WIFI_STA);
  Serial.printf("[%s] STA MAC=%s\n", NODE_NAME, formatMac(mac).c_str());
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  localEventSeq = static_cast<uint16_t>(esp_random());
  if (localEventSeq == 0) localEventSeq = 1;
  pinMode(TRIGGER_PIN, INPUT_PULLUP);
  pixels.begin();
  pixels.setBrightness(LED_BRIGHTNESS);
  clearGuideLed();
  initEspNow();
  printStaMac();
  Serial.printf("[%s] ready peers=%u mainPeer=%s channel=%u ledPin=%u\n",
                NODE_NAME, PEER_COUNT, HAS_MAIN_PEER ? "YES" : "NO", MESH_CHANNEL, LED_PIN);
}

void loop() {
  uint32_t now = millis();
  pollFireButton();

  processReceivedPackets();
  expireEvents(now);
  runMainGateway(now);
  runMeshRelay(now);
  delay(3);
}
