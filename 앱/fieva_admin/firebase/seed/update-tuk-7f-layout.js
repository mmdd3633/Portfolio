const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: `${serviceAccount.project_id}.firebasestorage.app`,
});

const bounds = {
  minX: 1198600.533753715,
  minY: -301854.5686132663,
  maxX: 1325176.65280529,
  maxY: -214173.5497363859,
};

const image = {
  width: 3547,
  height: 2616,
  coordinate_system: 'cad',
  origin: 'bottom-left',
  crop: {
    left: 455,
    top: 420,
    right: 3060,
    bottom: 2325,
  },
};
const mapId = 'TUK_7F_03d506d9';
const beaconUuid = 'f7826da6-4fa2-4e98-8024-bc5b71e0893e';
const storagePath = `cad_maps/${mapId}/tuk_7f_full.jpg`;
const bucketName = `${serviceAccount.project_id}.firebasestorage.app`;

function cadFromPixel(px, py) {
  return {
    x: bounds.minX + (px / image.width) * (bounds.maxX - bounds.minX),
    y: bounds.minY + (1 - py / image.height) * (bounds.maxY - bounds.minY),
  };
}

const beaconPixels = [
  { mapId: 'exit_west', docId: 'B01', px: 520, py: 2020, minor: 101, label: '서쪽 비상구', type: 'exit', isExit: true },
  { mapId: 'corridor_west', docId: 'B02', px: 900, py: 2020, minor: 102, label: '서쪽 복도', type: 'normal' },
  { mapId: 'corridor_mid_west', docId: 'B03', px: 1350, py: 2020, minor: 103, label: '중앙 서쪽 복도', type: 'normal' },
  { mapId: 'corridor_center', docId: 'B04', px: 1850, py: 2020, minor: 104, label: '중앙 복도', type: 'normal' },
  { mapId: 'corridor_mid_east', docId: 'B05', px: 2350, py: 2020, minor: 105, label: '중앙 동쪽 복도', type: 'normal' },
  { mapId: 'corridor_east', docId: 'B06', px: 2640, py: 2020, minor: 106, label: '동쪽 복도', type: 'normal' },
  { mapId: 'exit_east', docId: 'B07', px: 2820, py: 1950, minor: 107, label: '동쪽 비상구', type: 'exit', isExit: true },
  { mapId: 'corridor_north_1', docId: 'B08', px: 2640, py: 1740, minor: 108, label: '북쪽 복도 1', type: 'normal' },
  { mapId: 'corridor_north_2', docId: 'B09', px: 2640, py: 1120, minor: 109, label: '북쪽 복도 2', type: 'normal' },
  { mapId: 'exit_b09_front', docId: 'B10', px: 2700, py: 1120, minor: 110, label: 'B09 옆 비상구 앞', type: 'exit', isExit: true },
  { mapId: 'corridor_north_3', docId: 'B11', px: 2640, py: 760, minor: 111, label: '북쪽 복도 3', type: 'normal' },
  { mapId: 'exit_north', docId: 'B12', px: 2640, py: 524, minor: 112, label: '북쪽 비상구', type: 'exit', isExit: true },
  { mapId: 'classroom_708_home', docId: 'H', px: 2475, py: 1120, minor: 120, label: '강의실 708호 거주지', type: 'home' },
];

const beacons = beaconPixels.map((beacon) => ({
  id: beacon.mapId,
  name: beacon.docId,
  label: beacon.label,
  displayLabel: beacon.docId,
  type: beacon.type,
  isExit: beacon.isExit === true,
  ...cadFromPixel(beacon.px, beacon.py),
}));

const scannerBeacons = beaconPixels.map((beacon) => ({
  docId: beacon.docId,
  name: beacon.docId,
  label: beacon.label,
  displayLabel: beacon.docId,
  type: beacon.type,
  isExit: beacon.isExit === true,
  minor: beacon.minor,
  ...cadFromPixel(beacon.px, beacon.py),
}));

async function main() {
  const db = admin.firestore();
  const mapRef = db.collection('cad_maps').doc(mapId);
  const user = cadFromPixel(2475, 1120);
  const exitCount = beacons.filter((beacon) => beacon.isExit).length;

  await mapRef.set(
    {
      beacons,
      beacon_count: beacons.length,
      exit_count: exitCount,
      bounds,
      image_url: `gs://${bucketName}/${storagePath}`,
      image_path: storagePath,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
  await mapRef.update({ image });

  await db.collection('user_location').doc('unknown_user').set(
    {
      x: user.x,
      y: user.y,
      map_id: mapId,
      floor_id: mapId,
      beacon_id: 'H',
      status: 'active',
      last_updated: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  const batch = db.batch();
  for (const beacon of scannerBeacons) {
    const { docId, name, label, displayLabel, type, isExit, minor, x, y } = beacon;
    batch.set(
      db.collection('beacons').doc(docId),
      {
        name,
        uuid: beaconUuid,
        major: 1,
        minor,
        label,
        displayLabel,
        type,
        isExit,
        mapId,
        floorId: mapId,
        x,
        y,
        txPower: -59,
        onFire: false,
      },
      { merge: true },
    );
  }
  await batch.commit();

  await db.collection('status').doc('fire_system').set(
    {
      is_fire: false,
      location: '',
      description: 'Fire status cleared.',
      last_incident_time: new Date().toISOString(),
    },
    { merge: true },
  );

  console.log(JSON.stringify({ beaconCount: beacons.length, user, beacons }, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
