#include "robot.h"
#include <PRIZM_PRO.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

PRIZM prizm;

const uint32_t Z_STEP_FREQ_HZ = 5000;
const bool HOME_Z_ON_START = false;

const uint8_t Z_HOME_SENSOR_PIN = 9;
const unsigned long Z_HOME_TIMEOUT_MS = 15000;

const size_t LINE_BUFFER_SIZE = 96;

int currentZLength = 0;
char lineBuffer[LINE_BUFFER_SIZE];
size_t lineIndex = 0;
bool zMoveActive = false;

int32_t roundToInt32(float value) {
  return (int32_t)(value >= 0.0f ? value + 0.5f : value - 0.5f);
}

void printHelp() {
  Serial.println();
  Serial.println(F("Z serial control"));
  Serial.println(F("Input one relative Z value."));
  Serial.println(F("Examples: -150"));
  Serial.println(F("          z=-18"));
  Serial.println(F("Commands: help, status, stop, home"));
  Serial.println(F("Note: Z length is relative. Negative/positive direction follows robot.cpp."));
  Serial.println();
}

void printStatus() {
  Serial.print(F("Current Z length: "));
  Serial.println(currentZLength);
  Serial.print(F("Z move active: "));
  Serial.println(zMoveActive ? F("yes") : F("no"));
}

void toLowerAscii(char* text) {
  while (*text != '\0') {
    *text = (char)tolower((unsigned char)*text);
    text++;
  }
}

bool parseFloatValue(const char* text, float& outValue) {
  char* endPtr = nullptr;
  double parsed = strtod(text, &endPtr);
  if (endPtr == text || *endPtr != '\0') return false;
  outValue = (float)parsed;
  return true;
}

bool parseZLength(char* text, int& outLength) {
  char* valueText = text;

  char* equals = strchr(text, '=');
  if (equals != nullptr) {
    *equals = '\0';
    char* key = text;
    valueText = equals + 1;
    toLowerAscii(key);

    if (strcmp(key, "z") != 0 &&
        strcmp(key, "zlength") != 0 &&
        strcmp(key, "z_len") != 0) {
      Serial.print(F("Unknown key: "));
      Serial.println(key);
      return false;
    }
  }

  float parsed = 0.0f;
  if (!parseFloatValue(valueText, parsed)) return false;

  outLength = roundToInt32(parsed);
  return true;
}

bool homeZSafely() {
  if (digitalRead(Z_HOME_SENSOR_PIN) == LOW) {
    z_stop();
    Serial.println(F("[Z] sensor already active -> home complete"));
    return true;
  }

  Serial.println(F("[Z] safe home start"));
  z_go_home_start();
  unsigned long startMs = millis();

  while (millis() - startMs < Z_HOME_TIMEOUT_MS) {
    if (z_go_home_update()) {
      Serial.println(F("[Z] safe home complete"));
      return true;
    }
    delay(2);
  }

  z_stop();
  Serial.println(F("[Z] HOME TIMEOUT -> STOP"));
  return false;
}

void startZMove(int length) {
  if (length == 0) {
    z_stop();
    zMoveActive = false;
    currentZLength = 0;
    Serial.println(F("Z length is 0. Z stopped."));
    return;
  }

  z_stop();
  currentZLength = length;
  z_move_start(currentZLength);
  zMoveActive = true;

  Serial.print(F("Z move started -> "));
  Serial.println(currentZLength);
}

void stopZMove() {
  z_stop();
  zMoveActive = false;
  Serial.println(F("Z stopped."));
}

void processCommand(String command) {
  command.trim();
  if (command.length() == 0) return;

  Serial.print(F("RX: "));
  Serial.println(command);

  String lowerCommand = command;
  lowerCommand.toLowerCase();

  if (lowerCommand == "help" || lowerCommand == "?") {
    printHelp();
    return;
  }

  if (lowerCommand == "status") {
    printStatus();
    return;
  }

  if (lowerCommand == "stop") {
    stopZMove();
    return;
  }

  if (lowerCommand == "home" || lowerCommand == "home z") {
    stopZMove();
    if (!homeZSafely()) {
      Serial.println(F("Z homing failed."));
    }
    return;
  }

  char parseBuffer[LINE_BUFFER_SIZE];
  command.toCharArray(parseBuffer, sizeof(parseBuffer));

  int nextZLength = 0;
  if (!parseZLength(parseBuffer, nextZLength)) {
    Serial.println(F("Could not parse Z input. Type help for examples."));
    return;
  }

  startZMove(nextZLength);
  printStatus();
}

void submitLineBuffer() {
  lineBuffer[lineIndex] = '\0';
  processCommand(String(lineBuffer));
  lineIndex = 0;
}

void readSerialInput() {
  while (Serial.available() > 0) {
    char c = (char)Serial.read();

    if (c == '\r' || c == '\n') {
      if (lineIndex > 0) submitLineBuffer();
      return;
    }

    if (lineIndex < LINE_BUFFER_SIZE - 1) {
      lineBuffer[lineIndex++] = c;
    } else {
      lineIndex = 0;
      Serial.println(F("Input line too long. Cleared buffer."));
    }
  }
}

void updateZMotionState() {
  if (zMoveActive && z_move_update()) {
    zMoveActive = false;
    Serial.println(F("Z move complete."));
  }
}

void setup() {
  Serial.begin(115200);
  delay(300);
  Serial.println(F("Z-only serial move sketch starting."));

  prizm.PrizmBegin();

  FREQ = Z_STEP_FREQ_HZ;
  system_init();

  if (HOME_Z_ON_START) {
    if (!homeZSafely()) {
      Serial.println(F("Startup Z homing failed."));
    }
  }

  Serial.println(F("Ready for Z serial input."));
  printHelp();
}

void loop() {
  readSerialInput();
  updateZMotionState();
}
