const admin = require('firebase-admin');
const crypto = require('crypto');
const path = require('path');

const serviceAccount = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: `${serviceAccount.project_id}.firebasestorage.app`,
});

const mapId = 'TUK_7F_03d506d9';
const localFile = path.join(__dirname, '..', '..', 'firebase_tuk_map.jpg');
const storagePath = `cad_maps/${mapId}/tuk_7f_full.jpg`;
const bucketName = `${serviceAccount.project_id}.firebasestorage.app`;

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

async function main() {
  const bucket = admin.storage().bucket();
  const token = crypto.randomUUID();

  await bucket.upload(localFile, {
    destination: storagePath,
    metadata: {
      contentType: 'image/jpeg',
      metadata: {
        firebaseStorageDownloadTokens: token,
      },
      cacheControl: 'public,max-age=300',
    },
  });

  const mapRef = admin.firestore().collection('cad_maps').doc(mapId);
  await mapRef.set(
    {
      bounds,
      image_url: `gs://${bucketName}/${storagePath}`,
      image_path: storagePath,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
  await mapRef.update({ image });

  console.log(
    JSON.stringify(
      {
        mapId,
        storagePath,
        image,
      },
      null,
      2,
    ),
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
