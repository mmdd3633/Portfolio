/* eslint-disable no-console */
// Storage 버킷에 CORS 설정 — Web에서 이미지 접근 허용

const admin = require('firebase-admin');
const sa = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(sa),
  storageBucket: sa.project_id + '.firebasestorage.app',
});

async function main() {
  const bucket = admin.storage().bucket();
  const cors = [
    {
      origin: ['*'],
      method: ['GET', 'HEAD'],
      maxAgeSeconds: 3600,
      responseHeader: ['Content-Type', 'Cache-Control'],
    },
  ];
  await bucket.setCorsConfiguration(cors);
  console.log('CORS 설정 완료:', bucket.name);

  const [meta] = await bucket.getMetadata();
  console.log('현재 CORS:', JSON.stringify(meta.cors, null, 2));
}

main()
  .catch(err => console.error('ERROR:', err))
  .finally(() => process.exit(0));
