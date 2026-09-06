# 👨‍💻 Hi there, I'm Kim Gi-min!

한국공학대학교에서 전자공학을 전공(반도체 부전공)하고 있는 엔지니어 김기민입니다. 
하드웨어 설계(Verilog) 및 로봇/센서 제어부터, 실내 측위 기반의 모바일 애플리케이션 개발까지 **하드웨어와 소프트웨어를 아우르는 시스템 융합 및 문제 해결**에 강점을 가지고 있습니다. 

---

## 🛠 Tech Stack

### Languages & Software
<p>
  <img src="https://img.shields.io/badge/C-A8B9CC?style=for-the-badge&logo=c&logoColor=white">
  <img src="https://img.shields.io/badge/C++-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white">
</p>

### Hardware Design & Tools
<p>
  <img src="https://img.shields.io/badge/Verilog-153D70?style=for-the-badge">
  <img src="https://img.shields.io/badge/FPGA-25C2A0?style=for-the-badge">
  <img src="https://img.shields.io/badge/Arduino-00979D?style=for-the-badge&logo=arduino&logoColor=white">
</p>

---

## 🚀 Projects

### 1. BLE 비콘과 스마트폰을 활용한 실내 화재 대피 안내 시스템 (졸업 작품)
> **기간:** 2026.03 ~ 현재  
> **기술 스택:** BLE (Bluetooth Low Energy), Mobile App, Server/DB, C++

- **프로젝트 개요:** 복잡한 실내 환경에서 화재 발생 시, 실내에 구축된 BLE 비콘과 사용자의 스마트폰을 연동하여 실시간으로 최적의 안전 대피 경로를 안내하는 시스템 개발.
- **주요 구현 내용:**
  - **실시간 실내 측위 최적화:** BLE 비콘의 수신 신호 강도(RSSI) 데이터를 기반으로 노이즈 필터링(칼만 필터 등)을 적용하여 스마트폰 사용자의 현재 위치를 오차 범위를 최소화하여 추적.
  - **동적 대피 경로 탐색:** 화재 발생 위치를 시스템이 감지하면, 해당 구역을 회피하여 가장 빠른 비상구로 향할 수 있는 최적 대피 경로를 연산하고 모바일 앱에 표출.
  - **아키텍처 경량화 설계:** 긴급 재난 상황의 목적에 맞게 불필요한 기능(예: 별도의 유저 로그인)을 배제하고, 순수 측위 및 데이터 전송 서버 아키텍처 파이프라인 최적화.

### 2. 하드웨어 디지털 논리 회로 설계: CPU 데이터패스 및 디스플레이 제어
> **기술 스택:** Verilog HDL, FPGA

- **프로젝트 개요:** Verilog를 활용하여 디지털 신호 처리를 위한 하드웨어 모듈 및 7-Segment 디스플레이 제어 로직, 기본 CPU 데이터패스(Datapath) 설계.
- **주요 구현 내용:**
  - **동적 디스플레이 제어 로직 설계:** 여러 자릿수를 표현하기 위한 시분할 다중화(Time-multiplexing) 제어 로직 및 세그먼트 점등 제어 조합 논리 회로 설계.
  - **미초기화 상태 변수 디버깅:** 초기에 선언되지 않은 상태 변수가 개입하여 발생하는 타이밍 및 로직 오류를 추적하여 수정하고, 리소스 낭비 없이 안정적인 하드웨어 동작 상태 구현.

### 3. 반도체 웨이퍼 이송 로봇 설계 및 정밀 제어 (경진 대회)
> **기술 스택:** Motor Control, Sensor Interface, Embedded C

- **프로젝트 개요:** 반도체 제조 공정의 핵심 장비인 웨이퍼 이송 로봇(Wafer Transfer Robot)의 구동부를 설계하고 정밀 제어 알고리즘을 구현하여 이송 신뢰성을 확보.
- **주요 구현 내용:**
  - **정밀 가감속 제어 알고리즘:** 이송 중 웨이퍼의 파손 및 진동을 방지하기 위해 로봇 구동 모터의 정밀한 가감속(Acceleration/Deceleration) 프로파일 제어 로직 구현.
  - **로봇-센서 인터페이스 구축:** 센서 피드백을 활용하여 최적의 이송 경로와 속도를 산출하는 제어 메커니즘 구축.

---

## 📈 GitHub Stats
<p>
  <img src="https://github-readme-stats.vercel.app/api?username=본인깃허브아이디&show_icons=true&theme=radium" alt="Gi-min's GitHub Stats" />
</p>

<!-- 본인깃허브아이디 부분에 실제 GitHub Username을 입력해주세요. -->
