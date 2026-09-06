const admin = require('firebase-admin');
const crypto = require('crypto');
const path = require('path');

const serviceAccount = require('./service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: `${serviceAccount.project_id}.firebasestorage.app`,
});

const mapId = 'TUK_7F_03d506d9';
const localFile = path.join(__dirname, 'generated', 'tuk_7f_mobile_user_north2.jpg');
const storagePath = `cad_maps/${mapId}/tuk_7f_mobile_user_north2.jpg`;
const bucketName = `${serviceAccount.project_id}.firebasestorage.app`;

const mobileImage = {
  width: 900,
  height: 1950,
  coordinate_system: 'cad',
  origin: 'bottom-left',
  source_width: 3547,
  source_height: 2616,
  source_crop: {
    left: 2190,
    top: 350,
    right: 3090,
    bottom: 2300,
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
      cacheControl: 'public,max-age=60',
    },
  });

  await admin.firestore().collection('cad_maps').doc(mapId).update(
    {
      image_url: `gs://${bucketName}/${storagePath}`,
      image_path: storagePath,
      image: mobileImage,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    },
  );

  console.log(
    JSON.stringify(
      {
        mapId,
        storagePath,
        image: mobileImage,
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
