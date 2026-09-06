/* eslint-disable no-console */
const admin = require('firebase-admin');
const sa = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(sa),
  storageBucket: sa.project_id + '.firebasestorage.app',
});

async function main() {
  const db = admin.firestore();
  const bucket = admin.storage().bucket();

  console.log('=== cad_maps 전체 필드 ===');
  const snap = await db.collection('cad_maps').get();
  for (const doc of snap.docs) {
    const data = doc.data();
    console.log(`\n[${doc.id}]`);
    for (const key of Object.keys(data)) {
      if (key === 'beacons') {
        console.log(`  ${key}: (${data[key].length}개)`);
      } else {
        console.log(`  ${key}:`, JSON.stringify(data[key]));
      }
    }
  }

  console.log('\n=== map_results 이미지 metadata ===');
  const [files] = await bucket.getFiles({ prefix: 'map_results/' });
  for (const f of files) {
    const [meta] = await f.getMetadata();
    console.log(`\n${f.name}`);
    console.log('  size:', meta.size);
    console.log('  metadata:', JSON.stringify(meta.metadata, null, 2));
  }
}

main().catch(console.error).finally(() => process.exit(0));
