/**
 * Firebase Cloud Function trigger: Set custom claims for new users.
 * 
 * This trigger runs whenever a new user registers in Firebase Auth.
 * It assigns the `role: "authenticated"` claim automatically, ensuring 
 * all future users can authenticate with Supabase.
 * 
 * To deploy this function:
 * 1. Initialize Firebase Functions in your project:
 *    firebase init functions
 * 2. Copy this function to your `functions/index.js` file.
 * 3. Deploy:
 *    firebase deploy --only functions
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Admin SDK if not already initialized
if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.setSupabaseAuthenticatedRole = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  
  try {
    // Set custom user claim 'role' to 'authenticated'
    await admin.auth().setCustomUserClaims(uid, { role: 'authenticated' });
    console.log(`Successfully assigned "authenticated" role claim to new user: ${uid}`);
    return null;
  } catch (error) {
    console.error(`Error setting custom claims for user ${uid}:`, error);
    return null;
  }
});
