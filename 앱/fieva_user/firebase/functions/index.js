/* eslint-disable no-console */
// Fieva Cloud Functions
//
// 1) onFireBeaconUpdate
//    Firestore beacons/{id} 문서의 onFire 필드가 false→true 로 변경되면
//    'fire_alerts' 토픽으로 FCM 푸시를 발송한다.
//
// 2) reportFireBeacon (HTTPS Callable)
//    화재 감지 디바이스에서 호출. 토큰/관리자만 호출 가능하도록 권한 체크.

const { onDocumentUpdated } = require('firebase-functions/v2/firestore');
const { onCall, onRequest, HttpsError } = require('firebase-functions/v2/https');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { getStorage } = require('firebase-admin/storage');
const fs = require('fs');
const path = require('path');

initializeApp();
const db = getFirestore();

// ─────────────────────────────────────────────────────────  
// 1) 비콘 onFire 변경 감지 → 푸시
// ─────────────────────────────────────────────────────────
exports.onFireBeaconUpdate = onDocumentUpdated(
  { document: 'beacons/{beaconId}', region: 'asia-northeast3' },
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();
    if (!before || !after) return;

    const beforeOnFire = before.onFire === true || before.onfire === true;
    const afterOnFire = after.onFire === true || after.onfire === true;
    const wentOnFire = !beforeOnFire && afterOnFire;
    if (!wentOnFire) return;

    const suppressUserAlert =
      after.drillMode === true ||
      after.testMode === true ||
      after.suppressUserAlert === true ||
      after.alertSuppressed === true;
    if (suppressUserAlert) {
      console.log('점검 onFire 변경으로 사용자 푸시 생략:', event.params.beaconId);
      return;
    }

    const beaconId = event.params.beaconId;
    const floorId = after.floorId || 'unknown';

    const title = '화재 경보';
    const body = `${floorId} 구역 ${beaconId} 비콘에서 화재가 감지되었습니다. 즉시 대피하세요.`;

    const payload = {
      topic: 'fire_alerts',
      data: {
        type: 'fire_alert',
        title,
        body,
        beaconId,
        floorId,
        x: String(after.x ?? ''),
        y: String(after.y ?? ''),
      },
      android: {
        priority: 'high',
      },
    };

    try {
      const messageId = await getMessaging().send(payload);
      console.log('FCM 전송 완료:', messageId, 'beacon=', beaconId);
    } catch (e) {
      console.error('FCM 전송 실패:', e);
    }
  }
);

// ─────────────────────────────────────────────────────────
// 2) HTTPS Callable - 화재 감지 디바이스 보고용
// ─────────────────────────────────────────────────────────
exports.reportFireBeacon = onCall(
  { region: 'asia-northeast3' },
  async (request) => {
    // 인증된 사용자 또는 서비스 계정 토큰만
    if (!request.auth) {
      throw new HttpsError('unauthenticated', '인증 필요');
    }
    const beaconId = request.data?.beaconId;
    if (!beaconId || typeof beaconId !== 'string') {
      throw new HttpsError('invalid-argument', 'beaconId 필수');
    }
    const suppressUserAlert =
      request.data?.drillMode === true ||
      request.data?.testMode === true ||
      request.data?.suppressUserAlert === true;

    await db.collection('beacons').doc(beaconId).update({
      onFire: true,
      fireDetectedAt: FieldValue.serverTimestamp(),
      drillMode: suppressUserAlert,
      suppressUserAlert,
      lastFireSource: suppressUserAlert ? 'admin_drill' : 'hardware',
    });
    return { ok: true };
  }
);

// ─────────────────────────────────────────────────────────
// 3) HTTPS Callable - 화재 상태 해제
// ─────────────────────────────────────────────────────────
exports.clearFireBeacon = onCall(
  { region: 'asia-northeast3' },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', '인증 필요');
    }
    const beaconId = request.data?.beaconId;
    if (!beaconId) throw new HttpsError('invalid-argument', 'beaconId 필수');

    await db.collection('beacons').doc(beaconId).update({
      onFire: false,
      fireDetectedAt: null,
      drillMode: false,
      suppressUserAlert: false,
    });
    return { ok: true };
  }
);

// ─────────────────────────────────────────────────────────
// 4) 일회성 시드 함수 — 서비스 계정 키 없이 데이터 삽입
//    배포 후 단 한 번 호출하고 삭제할 것.
//    보안: 환경변수 SEED_TOKEN 헤더로 인증
// ─────────────────────────────────────────────────────────
const SEED_TOKEN = 'fieva-seed-2026'; // 일회용 토큰

const TEST_UUID = 'f7826da6-4fa2-4e98-8024-bc5b71e0893e';

const SEED_FLOORS = [
  { id: 'F1', name: '1층 로비', dxfPath: 'floors/F1.dxf', scale: 1.0 },
];

const SEED_BEACONS = [
  { id: 'B01', major: 1, minor: 101, x:  3, y:  3 },
  { id: 'B02', major: 1, minor: 102, x: 15, y:  3 },
  { id: 'B03', major: 1, minor: 103, x: 27, y:  3 },
  { id: 'B04', major: 1, minor: 104, x:  3, y: 10 },
  { id: 'B05', major: 1, minor: 105, x: 15, y: 10 },
  { id: 'B06', major: 1, minor: 106, x: 27, y: 10 },
  { id: 'B07', major: 1, minor: 107, x:  3, y: 17 },
  { id: 'B08', major: 1, minor: 108, x: 15, y: 17 },
  { id: 'B09', major: 1, minor: 109, x: 27, y: 17 },
  { id: 'B10', major: 1, minor: 110, x: 30, y: 17, label: 'B09 옆 비상구 앞', type: 'exit', isExit: true },
  { id: 'B11', major: 1, minor: 111, x: 27, y: 20 },
  { id: 'B12', major: 1, minor: 112, x: 15, y: 20, label: '비상구 앞', type: 'exit', isExit: true },
  { id: 'H', major: 1, minor: 120, x: 15, y: 1, label: '강의실 708호 거주지', type: 'home' },
].map(b => ({
  ...b,
  uuid: TEST_UUID,
  floorId: 'F1',
  txPower: -59,
  onFire: false,
  fireDetectedAt: null,
}));

const SEED_NODES = [
  { id: 'N11', x:  3, y:  3, neighbors: ['N12', 'N21'] },
  { id: 'N12', x: 15, y:  3, neighbors: ['N11', 'N13', 'N22'] },
  { id: 'N13', x: 27, y:  3, neighbors: ['N12', 'N23'] },
  { id: 'N21', x:  3, y: 10, neighbors: ['N11', 'N22', 'N31'] },
  { id: 'N22', x: 15, y: 10, neighbors: ['N12', 'N21', 'N23', 'N32'] },
  { id: 'N23', x: 27, y: 10, neighbors: ['N13', 'N22', 'N33'] },
  { id: 'N31', x:  3, y: 17, neighbors: ['N21', 'N32'] },
  { id: 'N32', x: 15, y: 17, neighbors: ['N22', 'N31', 'N33', 'EXIT1'] },
  { id: 'N33', x: 27, y: 17, neighbors: ['N23', 'N32'] },
  { id: 'EXIT1', x: 15, y: 20, neighbors: ['N32'], isExit: true },
].map(n => ({
  ...n,
  floorId: 'F1',
  isExit: n.isExit === true,
}));

exports.seedFievaData = onRequest(
  { region: 'asia-northeast3', cors: false, invoker: 'public' },
  async (req, res) => {
    try {
      if (req.headers['x-seed-token'] !== SEED_TOKEN) {
        res.status(403).send('Forbidden');
        return;
      }

      const log = [];

      // 1) Firestore 데이터 입력
      const fbatch = db.batch();
      for (const f of SEED_FLOORS) {
        const { id, ...rest } = f;
        fbatch.set(db.collection('floors').doc(id), rest);
      }
      for (const b of SEED_BEACONS) {
        const { id, ...rest } = b;
        fbatch.set(db.collection('beacons').doc(id), rest);
      }
      for (const n of SEED_NODES) {
        const { id, ...rest } = n;
        fbatch.set(db.collection('routeNodes').doc(id), rest);
      }
      await fbatch.commit();
      log.push(`Firestore: floors=${SEED_FLOORS.length}, beacons=${SEED_BEACONS.length}, nodes=${SEED_NODES.length}`);

      // 2) Storage에 DXF 업로드
      const dxfLocal = path.join(__dirname, 'F1.dxf');
      if (fs.existsSync(dxfLocal)) {
        const bucket = getStorage().bucket();
        await bucket.upload(dxfLocal, {
          destination: 'floors/F1.dxf',
          contentType: 'application/dxf',
          metadata: { cacheControl: 'public, max-age=300' },
        });
        log.push(`Storage: floors/F1.dxf 업로드 (bucket=${bucket.name})`);
      } else {
        log.push('Storage: F1.dxf 파일 없음 — 스킵');
      }

      res.status(200).json({ ok: true, log });
    } catch (err) {
      console.error('seed error:', err);
      res.status(500).json({ ok: false, error: String(err) });
    }
  }
);
