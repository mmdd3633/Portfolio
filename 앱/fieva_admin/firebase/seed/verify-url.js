/* eslint-disable no-console */
// Storage 다운로드 URL이 제대로 동작하는지 검증

const admin = require('firebase-admin');
const https = require('https');
const sa = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(sa),
  storageBucket: sa.project_id + '.firebasestorage.app',
});

function fetchHead(url) {
  return new Promise((resolve, reject) => {
    https.get(url, res => {
      resolve({ status: res.statusCode, headers: res.headers });
      res.resume();
    }).on('error', reject);
  });
}

async function main() {
  const bucket = admin.storage().bucket();
  const file = bucket.file('map_results/TUK_7F_03d506d9.jpg');

  // Signed URL은 service-account 권한이라 다름 — 실제 Web SDK는 다른 형식
  // 일단 firebasestorage.googleapis.com 형식의 토큰 URL을 만들어서 테스트
  const [meta] = await file.getMetadata();
  const token = meta.metadata && meta.metadata.firebaseStorageDownloadTokens;

  if (!token) {
    console.log('토큰 없음. 새로 생성합니다...');
    const newToken = require('crypto').randomBytes(16).toString('hex');
    await file.setMetadata({
      metadata: {
        firebaseStorageDownloadTokens: newToken,
      },
    });
    console.log('새 토큰:', newToken);
  } else {
    console.log('기존 토큰:', token);
  }

  const finalToken = token || (await file.getMetadata())[0].metadata.firebaseStorageDownloadTokens;
  const downloadUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(file.name)}?alt=media&token=${finalToken.split(',')[0]}`;

  console.log('\nDownload URL:', downloadUrl);

  console.log('\n=== HEAD 요청 결과 ===');
  const result = await fetchHead(downloadUrl);
  console.log('Status:', result.status);
  console.log('Content-Type:', result.headers['content-type']);
  console.log('Content-Length:', result.headers['content-length']);
  console.log('Access-Control-Allow-Origin:', result.headers['access-control-allow-origin'] || '(없음)');
}

main()
  .catch(err => console.error('ERROR:', err.message))
  .finally(() => process.exit(0));
