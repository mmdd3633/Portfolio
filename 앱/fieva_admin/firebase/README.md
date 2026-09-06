# Fieva Firebase 백엔드

Firestore 시드 데이터 + Cloud Functions + Storage 업로드 스크립트.

## 폴더 구조

```
firebase/
├── firebase.json              # Firebase CLI 설정
├── .firebaserc                # 프로젝트 ID (rssi-test-df593)
├── firestore.rules            # Firestore 보안 규칙
├── firestore.indexes.json     # 복합 인덱스
├── storage.rules              # Storage 보안 규칙
├── functions/                 # Cloud Functions
│   ├── index.js               # onFire 감지 → FCM 푸시
│   └── package.json
├── seed/                      # 초기 데이터 시드
│   ├── seed.js                # Firestore 데이터 삽입
│   ├── upload-dxf.js          # 도면 파일 Storage 업로드
│   └── package.json
└── sample-dxf/
    └── F1.dxf                 # 테스트용 30m×20m 평면도
```

## 1단계: 서비스 계정 키 준비

1. [Firebase 콘솔](https://console.firebase.google.com/project/rssi-test-df593/settings/serviceaccounts/adminsdk) 접속
2. **새 비공개 키 생성** 클릭 → JSON 파일 다운로드
3. 파일을 `firebase/seed/service-account.json`으로 저장
   (이 파일은 .gitignore되어 있습니다)

## 2단계: 시드 데이터 입력

```powershell
cd C:\dev\fieva\fieva_app\firebase\seed
npm install
npm run seed
```

다음이 생성됩니다:
- `floors/F1` — 1층 메타 정보
- `beacons/B01 ~ B09` — 9개 비콘 (3×3 격자, 동일 UUID)
- `routeNodes/N11 ~ N33, EXIT1` — 경로 그래프 + 비상구

## 3단계: 샘플 DXF 도면 업로드

```powershell
npm run upload:dxf
```

`sample-dxf/F1.dxf`가 Storage의 `floors/F1.dxf`로 업로드됩니다.

## 4단계: Cloud Functions 배포

```powershell
cd C:\dev\fieva\fieva_app\firebase\functions
npm install
cd ..
firebase deploy --only functions
```

Blaze(종량제) 플랜 필요. 무료 Spark 플랜이면 에뮬레이터로 테스트:
```powershell
firebase emulators:start --only functions,firestore
```

## 5단계: 보안 규칙 배포

```powershell
cd C:\dev\fieva\fieva_app\firebase
firebase deploy --only firestore:rules,storage
```

## 화재 알림 테스트

### 방법 1: Firebase 콘솔에서 수동 토글
1. 콘솔 → Firestore → `beacons/B05` 문서 열기
2. `onFire` 필드를 `true`로 변경 → 저장
3. 앱에 푸시 알림 도착 + 빨간 마커 + 음성 안내

### 방법 2: Functions Callable 호출
앱에서:
```dart
await FirebaseFunctions.instanceFor(region: 'asia-northeast3')
    .httpsCallable('reportFireBeacon')
    .call({'beaconId': 'B05'});
```

해제할 때:
```dart
await FirebaseFunctions.instanceFor(region: 'asia-northeast3')
    .httpsCallable('clearFireBeacon')
    .call({'beaconId': 'B05'});
```

## 데이터 스키마

### `floors/{floorId}`
| 필드 | 타입 | 설명 |
|---|---|---|
| `name` | string | 표시 이름 |
| `dxfPath` | string | Storage 상대 경로 |
| `scale` | number | (예약) 단위 보정 배율 |

### `beacons/{beaconId}`
| 필드 | 타입 | 설명 |
|---|---|---|
| `uuid` | string | iBeacon UUID |
| `major` / `minor` | number | iBeacon Major/Minor |
| `x` / `y` | number | 도면 좌표(m) |
| `floorId` | string | 소속 층 |
| `txPower` | number | 1m 거리에서의 RSSI (캘리브레이션) |
| `onFire` | bool | 화재 감지 여부 |
| `fireDetectedAt` | timestamp | 감지 시각 |

### `routeNodes/{nodeId}`
| 필드 | 타입 | 설명 |
|---|---|---|
| `x` / `y` | number | 도면 좌표(m) |
| `floorId` | string | 소속 층 |
| `isExit` | bool | 비상구 여부 |
| `neighbors` | string[] | 인접 노드 ID 목록 |

## 좌표계 주의

샘플은 **m 단위**로 통일되어 있습니다 (30m × 20m). 실제 도면이 mm 단위라면 `seed.js`의 좌표값과 DXF 파일을 동일 단위로 맞춰주세요.
