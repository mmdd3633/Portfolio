/* eslint-disable no-console */
// 기존 Firebase 데이터 구조 조사

const admin = require('firebase-admin');
const sa = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(sa),
  storageBucket: sa.project_id + '.firebasestorage.app',
});

async function main() {
  const db = admin.firestore();
  const bucket = admin.storage().bucket();

  console.log('\n=== Firestore Collections ===');
  const collections = await db.listCollections();
  for (const col of collections) {
    const snap = await col.limit(3).get();
    console.log(`\n[${col.id}] (총 ${(await col.count().get()).data().count}개)`);
    snap.docs.forEach(doc => {
      console.log(`  - ${doc.id}:`, JSON.stringify(doc.data(), null, 2).split('\n').join('\n    '));
    });
  }

  console.log('\n\n=== Storage Files ===');
  const [files] = await bucket.getFiles();
  files.forEach(f => {
    console.log(`  ${f.name} | ${f.metadata.contentType || '-'} | ${f.metadata.size || '-'} bytes`);
  });
}

main()
  .catch(err => console.error('ERROR:', err))
  .finally(() => process.exit(0));
