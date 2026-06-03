/**
 * Migration Script: Set custom claims for existing Firebase Auth users.
 * 
 * This script loops through all users in your Firebase project and sets the
 * custom claim `role: "authenticated"` so that Supabase can authorize them.
 * 
 * To run this script:
 * 1. Download your service account key from the Firebase Console (Settings > Service Accounts).
 * 2. Save it as `serviceAccountKey.json` in the same directory or set the environment variable:
 *    export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccountKey.json"
 * 3. Run:
 *    npm install firebase-admin
 *    node migrate_existing_users.js
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
// It will automatically use the GOOGLE_APPLICATION_CREDENTIALS environment variable
if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault()
  });
} else {
  console.log('Error: GOOGLE_APPLICATION_CREDENTIALS environment variable is not set.');
  console.log('Please set it to the path of your Firebase service account JSON key file.');
  process.exit(1);
}

const auth = admin.auth();

async function setClaimsForUser(uid) {
  try {
    await auth.setCustomUserClaims(uid, { role: 'authenticated' });
    console.log(`Successfully set claims for user: ${uid}`);
  } catch (error) {
    console.error(`Failed to set claims for user ${uid}:`, error);
  }
}

async function migrateAllUsers() {
  console.log('Starting migration to assign "authenticated" role claims to all Firebase users...');
  
  let nextPageToken;
  let count = 0;
  
  do {
    try {
      const listUsersResult = await auth.listUsers(1000, nextPageToken);
      
      for (const userRecord of listUsersResult.users) {
        await setClaimsForUser(userRecord.uid);
        count++;
      }
      
      nextPageToken = listUsersResult.nextPageToken;
    } catch (error) {
      console.error('Error listing users:', error);
      process.exit(1);
    }
  } while (nextPageToken);
  
  console.log(`Migration complete! Successfully processed ${count} users.`);
}

migrateAllUsers();
