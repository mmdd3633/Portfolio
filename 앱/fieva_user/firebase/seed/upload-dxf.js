/* eslint-disable no-console */
// Storage에 sample.dxf 파일을 floors/F1.dxf 경로로 업로드
//
// 사용법:
//   1. service-account.json 준비
//   2. npm run upload:dxf

const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

const serviceAccount = require(path.resolve(__dirname, 'service-account.json'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: `${serviceAccount.project_id}.firebasestorage.app`,
});

async function main() {
  const localPath = path.resolve(__dirname, '..', 'sample-dxf', 'F1.dxf');
  if (!fs.existsSync(localPath)) {
    console.error('파일 없음:', localPath);
    process.exit(1);
  }
  const bucket = admin.storage().bucket();
  console.log('업로드 중:', localPath, '→', `gs://${bucket.name}/floors/F1.dxf`);
  await bucket.upload(localPath, {
    destination: 'floors/F1.dxf',
    contentType: 'application/dxf',
  });
  console.log('✅ 업로드 완료');
}

main()
  .catch(err => {
    console.error(err);
    process.exit(1);
  })
  .finally(() => process.exit(0));
