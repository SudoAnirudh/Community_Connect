/**
 * Script: Sync users from Firebase Auth to Supabase database.
 *
 * This script lists all users in your Firebase project and inserts/upserts them
 * into the Supabase `users` database table.
 *
 * To run:
 * 1. Set environment variables:
 *    export SUPABASE_SERVICE_ROLE_KEY="your-supabase-service-role-key"
 * 2. Run:
 *    node sync_users.js
 */

const admin = require("firebase-admin");
const path = require("path");

// Fetch Supabase details
const SUPABASE_URL = "https://mktzujpsqyiemfcyjoaj.supabase.co";
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Error: SUPABASE_SERVICE_ROLE_KEY environment variable is not set.");
  console.error("Please run: export SUPABASE_SERVICE_ROLE_KEY='...' before executing this script.");
  process.exit(1);
}

// Locate service account JSON
const serviceAccountPath = path.join(__dirname, "communityconnect-eb5e1-firebase-adminsdk-fbsvc-b4790f794e.json");

try {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccountPath),
  });
} catch (error) {
  console.error("Failed to initialize Firebase Admin SDK. Make sure the JSON file exists at:", serviceAccountPath);
  console.error(error);
  process.exit(1);
}

const auth = admin.auth();

async function syncUserToSupabase(userRecord) {
  const uid = userRecord.uid;
  const phone = userRecord.phoneNumber || "";
  const name = userRecord.displayName || "Neighbor";
  const createdAt = new Date(userRecord.metadata.creationTime).toISOString();

  // We perform an upsert (ON CONFLICT (uid) DO UPDATE) by setting Prefer header
  const response = await fetch(`${SUPABASE_URL}/rest/v1/users`, {
    method: "POST",
    headers: {
      "apikey": SUPABASE_SERVICE_ROLE_KEY,
      "Authorization": `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
      "Content-Type": "application/json",
      "Prefer": "resolution=merge-duplicates",
    },
    body: JSON.stringify({
      uid: uid,
      phone: phone,
      name: name,
      role: "member",
      created_at: createdAt,
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Failed to sync user ${uid} to Supabase: ${response.statusText} - ${errorText}`);
  }
}

async function startSync() {
  console.log("Starting Firebase to Supabase user synchronization...");
  let nextPageToken;
  let count = 0;

  do {
    try {
      const listUsersResult = await auth.listUsers(1000, nextPageToken);

      for (const userRecord of listUsersResult.users) {
        // Only sync if the user has a phone number (standard users)
        if (userRecord.phoneNumber) {
          console.log(`Syncing user: ${userRecord.uid} (${userRecord.phoneNumber})`);
          await syncUserToSupabase(userRecord);
          count++;
        } else {
          console.log(`Skipping anonymous/non-phone user: ${userRecord.uid}`);
        }
      }

      nextPageToken = listUsersResult.nextPageToken;
    } catch (error) {
      console.error("Error during sync iteration:", error);
      process.exit(1);
    }
  } while (nextPageToken);

  console.log(`Synchronization complete! Pushed ${count} phone-authenticated users into Supabase.`);
}

startSync();
