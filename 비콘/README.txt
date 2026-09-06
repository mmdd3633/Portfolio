# FIEVA ESP32 비콘 네트워크

FIEVA 앱의 실내 위치 추정과 대피 안내를 지원하기 위해 제작한 ESP32 기반 BLE 비콘 네트워크입니다.

비콘은 BLE 신호를 송출하여 사용자 앱의 위치 추정에 사용됩니다. 화재 테스트가 시작되면 ESP-NOW 통신으로 상태를 전달받아 LED를 통해 대피 방향을 표시합니다.

## 구성

- Main: Firebase의 관리자 화재 테스트 상태를 확인하고 ESP-NOW로 비콘에 시작·종료 명령 전달
- BeaconUnified: 일반 구역용 BLE 비콘 및 LED 대피 안내 장치
- H: H708 구역에 맞춘 전용 LED 안내 비콘

## 동작 흐름

관리자 앱 → Firebase → Main ESP32 → ESP-NOW → 각 비콘 → BLE 신호 및 LED 안내 → 사용자 앱

## 기술

ESP32, BLE, ESP-NOW, LED 제어, Firebase 연동

본 프로젝트는 실험 및 연구 목적의 프로토타입입니다.
