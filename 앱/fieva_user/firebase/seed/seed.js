/* eslint-disable no-console */
// Fieva Firestore 시드 스크립트
//
// 사용법:
//   1. Firebase 콘솔 → 프로젝트 설정 → 서비스 계정 → 새 비공개 키 생성 → service-account.json 다운로드
//   2. 이 폴더(seed/)에 service-account.json 파일을 둔다.
//   3. npm install
//   4. npm run seed        # 데이터 삽입
//      npm run seed:clear  # 기존 데이터 삭제 후 삽입

const admin = require('firebase-admin');
const path = require('path');

const serviceAccount = require(path.resolve(__dirname, 'service-account.json'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const clear = process.argv.includes('--clear');

// ── 1) 층(floor) 정보 ─────────────────────────────────────
const floors = [
  {
    id: 'F1',
    name: '1층 로비',
    dxfPath: 'floors/F1.dxf',
    scale: 1.0,
  },
];

// ── 2) 비콘 정보 ──────────────────────────────────────────
// 도면 좌표계와 동일한 단위 (m). 본 예시는 30m x 20m 공간 가정.
const TEST_UUID = 'f7826da6-4fa2-4e98-8024-bc5b71e0893e';
const beacons = [
  { id: 'B01', major: 1, minor: 101, x:  3, y:  3, txPower: -59 },
  { id: 'B02', major: 1, minor: 102, x: 15, y:  3, txPower: -59 },
  { id: 'B03', major: 1, minor: 103, x: 27, y:  3, txPower: -59 },
  { id: 'B04', major: 1, minor: 104, x:  3, y: 10, txPower: -59 },
  { id: 'B05', major: 1, minor: 105, x: 15, y: 10, txPower: -59 },
  { id: 'B06', major: 1, minor: 106, x: 27, y: 10, txPower: -59 },
  { id: 'B07', major: 1, minor: 107, x:  3, y: 17, txPower: -59 },
  { id: 'B08', major: 1, minor: 108, x: 15, y: 17, txPower: -59 },
  { id: 'B09', major: 1, minor: 109, x: 27, y: 17, txPower: -59 },
  { id: 'B10', major: 1, minor: 110, x: 30, y: 17, txPower: -59, label: 'B09 옆 비상구 앞', type: 'exit', isExit: true },
  { id: 'B11', major: 1, minor: 111, x: 27, y: 20, txPower: -59 },
  { id: 'B12', major: 1, minor: 112, x: 15, y: 20, txPower: -59, label: '비상구 앞', type: 'exit', isExit: true },
  { id: 'H', major: 1, minor: 120, x: 15, y: 1, txPower: -59, label: '강의실 708호 거주지', type: 'home' },
].map(b => ({
  ...b,
  uuid: TEST_UUID,
  floorId: 'F1',
  onFire: false,
  fireDetectedAt: null,
}));

// ── 3) 경로 노드(routeNodes) ──────────────────────────────
// 격자형 그래프 (3x3 + 출입구 1개)
const nodes = [
  { id: 'N11', x:  3, y:  3, neighbors: ['N12', 'N21'] },
  { id: 'N12', x: 15, y:  3, neighbors: ['N11', 'N13', 'N22'] },
  { id: 'N13', x: 27, y:  3, neighbors: ['N12', 'N23'] },
  { id: 'N21', x:  3, y: 10, neighbors: ['N11', 'N22', 'N31'] },
  { id: 'N22', x: 15, y: 10, neighbors: ['N12', 'N21', 'N23', 'N32'] },
  { id: 'N23', x: 27, y: 10, neighbors: ['N13', 'N22', 'N33'] },
  { id: 'N31', x:  3, y: 17, neighbors: ['N21', 'N32'] },
  { id: 'N32', x: 15, y: 17, neighbors: ['N22', 'N31', 'N33', 'EXIT1'] },
  { id: 'N33', x: 27, y: 17, neighbors: ['N23', 'N32'] },
  // 비상구
  { id: 'EXIT1', x: 15, y: 20, neighbors: ['N32'], isExit: true },
].map(n => ({
  ...n,
  floorId: 'F1',
  isExit: n.isExit === true,
}));

async function clearCollection(name) {
  const snap = await db.collection(name).get();
  console.log(`[clear] ${name}: ${snap.size} 문서 삭제`);
  const batch = db.batch();
  snap.docs.forEach(d => batch.delete(d.ref));
  await batch.commit();
}

async function writeAll(name, items, idField = 'id') {
  console.log(`[write] ${name}: ${items.length} 문서`);
  const batch = db.batch();
  for (const item of items) {
    const id = item[idField];
    const data = { ...item };
    delete data[idField];
    batch.set(db.collection(name).doc(id), data);
  }
  await batch.commit();
}

async function main() {
  if (clear) {
    await clearCollection('floors');
    await clearCollection('beacons');
    await clearCollection('routeNodes');
  }
  await writeAll('floors', floors);
  await writeAll('beacons', beacons);
  await writeAll('routeNodes', nodes);
  console.log('\n✅ 시드 완료');
  console.log('   - floors:', floors.length);
  console.log('   - beacons:', beacons.length);
  console.log('   - routeNodes:', nodes.length);
  console.log('\n다음 단계: npm run upload:dxf 로 샘플 도면 업로드');
}

main()
  .catch(err => {
    console.error(err);
    process.exit(1);
  })
  .finally(() => process.exit(0));
