const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { createClient } = require("@supabase/supabase-js");

admin.initializeApp();

/**
 * HTTP Cloud Function to send FCM push notifications.
 * Triggered via a Supabase Database Webhook whenever a new row is inserted into the `notices` table.
 */
exports.sendNoticeNotificationHttp = functions.https.onRequest(async (req, res) => {
  // Only accept POST requests
  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }

  const payload = req.body;
  
  // Verify that the request body matches a Supabase Webhook payload format
  if (!payload || payload.type !== "INSERT" || !payload.record) {
    console.error("Invalid Supabase webhook payload structure received:", payload);
    return res.status(400).send("Invalid Supabase Webhook Payload");
  }

  const { title, description } = payload.record;
  if (!title || !description) {
    console.error("Missing notice details in webhook payload:", payload.record);
    return res.status(400).send("Missing notice title or description");
  }

  // Fetch Supabase configuration from environment variables
  // (Set these in Firebase functions environment config using:
  //  firebase functions:config:set supabase.url="..." supabase.service_key="...")
  const supabaseUrl = process.env.SUPABASE_URL || (functions.config().supabase && functions.config().supabase.url);
  const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || (functions.config().supabase && functions.config().supabase.service_key);

  if (!supabaseUrl || !supabaseServiceKey) {
    console.error("Missing Supabase configuration in environment variables.");
    return res.status(500).send("Supabase credentials not configured in Cloud Functions.");
  }

  try {
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Fetch all user records with non-empty FCM tokens
    const { data: users, error } = await supabase
      .from("users")
      .select("fcm_token")
      .not("fcm_token", "is", null);

    if (error) {
      throw error;
    }

    // Filter valid, non-blank tokens
    const tokens = users
      .map((u) => u.fcm_token)
      .filter((token) => token && token.trim() !== "");

    if (tokens.length === 0) {
      console.log("No registered devices found with valid FCM tokens.");
      return res.status(200).send("No tokens to notify.");
    }

    const fcmPayload = {
      notification: {
        title: title,
        body: description,
      },
      tokens: tokens,
    };

    // Dispatch FCM notifications
    const response = await admin.messaging().sendEachForMulticast(fcmPayload);
    console.log(`Dispatched notices push: ${response.successCount} successful out of ${tokens.length}`);
    return res.status(200).json({
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
  } catch (err) {
    console.error("Failed to process notice notification dispatch:", err);
    return res.status(500).send(`Error processing notification: ${err.message || err}`);
  }
});
