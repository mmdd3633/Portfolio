# Fieva 안드로이드 앱 설치 가이드

실내 화재 대피 안내 안드로이드 앱. Flutter + Firebase + iBeacon 기반.

## 1. Firebase 프로젝트 연결

이미 Firebase Functions를 사용 중이라면 같은 프로젝트에 연결하세요.

```powershell
# FlutterFire CLI 설치 (한 번만)
dart pub global activate flutterfire_cli

# 프로젝트 디렉토리에서
cd C:\dev\fieva\fieva_app
flutterfire configure
```

명령어 실행 후 기존 Firebase 프로젝트를 선택하면 `lib/firebase_options.dart`가 자동 생성됩니다. `main.dart`에서 이 옵션을 사용하도록 다음과 같이 수정하세요.

```dart
import 'firebase_options.dart';
// ...
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## 2. Firestore 데이터 구조

앱은 다음 컬렉션을 읽습니다.

### `floors/{floorId}`
```json
{
  "name": "1층 로비",
  "dxfPath": "floors/F1.dxf",
  "scale": 1.0
}
```
- `dxfPath`: Firebase Storage 상대 경로 (Functions가 생성한 DXF를 이곳에 업로드)

### `beacons/{beaconId}`
```json
{
  "uuid": "f7826da6-4fa2-4e98-8024-bc5b71e0893e",
  "major": 1,
  "minor": 101,
  "x": 12.5,
  "y": 8.2,
  "floorId": "F1",
  "txPower": -59,
  "onFire": false,
  "fireDetectedAt": null
}
```
- `x`, `y`: DXF 도면 좌표계와 동일한 단위(m)
- `onFire`: 화재 감지 센서가 true로 바꾸면 즉시 앱에 반영됨
- `txPower`: 1m 거리에서의 RSSI 캘리브레이션 값

### `routeNodes/{nodeId}`
```json
{
  "x": 10.0,
  "y": 5.0,
  "floorId": "F1",
  "isExit": false,
  "neighbors": ["node_2", "node_3"]
}
```
- 비상구는 `isExit: true`
- `neighbors`: 양방향으로 양쪽 모두 지정 권장

## 3. Firebase Storage 규칙

DXF 파일은 인증 없이 읽기만 허용해도 무방합니다. 쓰기는 Functions/Admin만 가능하도록 설정.

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /floors/{floorId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 4. FCM 화재 알림 (선택)

Cloud Function에서 `onFire: true` 변경 시 토픽 푸시:

```javascript
exports.fireAlert = functions.firestore
  .document('beacons/{id}')
  .onUpdate(async (change) => {
    const before = change.before.data();
    const after = change.after.data();
    if (!before.onFire && after.onFire) {
      await admin.messaging().send({
        topic: 'fire_alerts',
        notification: {
          title: '화재 경보',
          body: `${after.floorId} 구역에서 화재가 감지되었습니다`,
        },
      });
    }
  });
```

앱은 이미 `fire_alerts` 토픽을 구독합니다.

## 5. 빌드 및 실행

```powershell
cd C:\dev\fieva\fieva_app
flutter pub get
flutter run             # 연결된 안드로이드 기기/에뮬레이터
flutter build apk       # APK 빌드
```

## 6. 권한 확인 사항

앱 첫 실행 시 다음 권한이 요청됩니다:
- 위치(BLE 스캔 필수)
- 블루투스 스캔/연결
- 알림(Android 13+)

권한 거부 시 비콘 스캔이 동작하지 않으니, 거부 후 다시 허용하려면 설정 → 앱 → Fieva → 권한에서 변경.

## 7. 좌표계 일관성 주의

DXF 파일, 비콘 `x/y`, 경로 노드 `x/y`는 **모두 동일한 좌표계와 단위**여야 합니다. DXF가 mm 단위라면 Firestore의 모든 좌표도 mm 단위, m 단위라면 모두 m로 통일하세요.

## 8. 테스트용 더미 데이터

비콘 없이 UI만 확인하려면 `lib/screens/map_screen.dart`의 `_bootstrap()` 시작 부분에 임시로:
```dart
setState(() {
  _userPos = EstimatedPosition(x: 10, y: 10, accuracy: 1, floorId: 'F1', timestamp: DateTime.now());
});
```
를 추가해 위치를 고정할 수 있습니다.
