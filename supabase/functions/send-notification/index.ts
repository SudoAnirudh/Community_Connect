import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { create, getNumericDate } from "https://deno.land/x/djwt@v2.9/mod.ts";

serve(async (req) => {
  // Only accept POST requests
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  // Enforce authentication via WEBHOOK_SECRET
  const webhookSecret = Deno.env.get("WEBHOOK_SECRET");
  if (!webhookSecret) {
    console.error("WEBHOOK_SECRET is not configured in Supabase env.");
    return new Response("Server Configuration Error", { status: 500 });
  }

  const authHeader = req.headers.get("Authorization");
  if (authHeader !== `Bearer ${webhookSecret}`) {
    return new Response("Unauthorized", { status: 401 });
  }

  try {
    const payload = await req.json();

    // Verify webhook payload
    if (!payload || payload.type !== "INSERT" || !payload.record) {
      console.error("Invalid Supabase webhook payload:", payload);
      return new Response("Invalid Webhook Payload", { status: 400 });
    }

    const { title, description } = payload.record;
    if (!title || !description) {
      console.error("Notice details missing in payload:", payload.record);
      return new Response("Missing title or description", { status: 400 });
    }

    // 1. Read Firebase Service Account JSON from Env Secrets
    const serviceAccountStr = Deno.env.get("FIREBASE_SERVICE_ACCOUNT");
    if (!serviceAccountStr) {
      console.error("FIREBASE_SERVICE_ACCOUNT secret not configured in Supabase.");
      return new Response("Firebase Service Account Secret Missing", { status: 500 });
    }

    const serviceAccount = JSON.parse(serviceAccountStr);
    const projectId = serviceAccount.project_id;
    const clientEmail = serviceAccount.client_email;
    const privateKeyPem = serviceAccount.private_key;

    if (!projectId || !clientEmail || !privateKeyPem) {
      console.error("Invalid service account JSON structure.");
      return new Response("Invalid Service Account Secret", { status: 500 });
    }

    // 2. Generate Google OAuth2 Token using RS256 Web Crypto
    const accessToken = await getGoogleAccessToken(clientEmail, privateKeyPem);

    // 3. Initialize Supabase Client
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // 4. Fetch user FCM tokens
    const { data: users, error } = await supabase
      .from("users")
      .select("fcm_token")
      .not("fcm_token", "is", null);

    if (error) {
      throw error;
    }

    const tokens = users
      .map((u: any) => u.fcm_token)
      .filter((token: string) => token && token.trim() !== "");

    if (tokens.length === 0) {
      console.log("No registered devices found with valid FCM tokens.");
      return new Response(JSON.stringify({ successCount: 0, msg: "No tokens to notify" }), {
        headers: { "Content-Type": "application/json" },
        status: 200,
      });
    }

    // 5. Concurrently dispatch push notifications via FCM v1 API
    const sendPromises = tokens.map(async (token: string) => {
      try {
        const res = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
          method: "POST",
          headers: {
            "Authorization": `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            message: {
              token: token,
              notification: {
                title: title,
                body: description,
              },
            },
          }),
        });
        
        if (!res.ok) {
          const errText = await res.text();
          console.error(`FCM send error for token ${token.substring(0, 10)}...:`, errText);
          return false;
        }
        return true;
      } catch (e) {
        console.error(`Network error sending to token ${token.substring(0, 10)}...:`, e);
        return false;
      }
    });

    const results = await Promise.all(sendPromises);
    const successCount = results.filter(Boolean).length;
    const failureCount = results.length - successCount;

    console.log(`Dispatched notices push: ${successCount} successful, ${failureCount} failed.`);

    return new Response(JSON.stringify({ successCount, failureCount }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (err: any) {
    console.error("Failed to process notice notification dispatch:", err);
    return new Response(`Error: ${err.message || err}`, { status: 500 });
  }
});

/**
 * Signs a JWT assertion and exchanges it for a Google OAuth2 access token.
 */
async function getGoogleAccessToken(clientEmail: string, privateKeyPem: string): Promise<string> {
  // Extract and parse private key raw base64 data
  const pemHeader = "-----BEGIN PRIVATE KEY-----";
  const pemFooter = "-----END PRIVATE KEY-----";
  
  // Clean PEM headers/footers and white spaces
  let cleanedKey = privateKeyPem.trim();
  if (cleanedKey.startsWith(pemHeader)) {
    cleanedKey = cleanedKey.substring(pemHeader.length);
  }
  if (cleanedKey.endsWith(pemFooter)) {
    cleanedKey = cleanedKey.substring(0, cleanedKey.length - pemFooter.length);
  }
  cleanedKey = cleanedKey.replace(/\s/g, "");

  const binaryDerString = atob(cleanedKey);
  const binaryDer = new Uint8Array(binaryDerString.length);
  for (let i = 0; i < binaryDerString.length; i++) {
    binaryDer[i] = binaryDerString.charCodeAt(i);
  }

  // Import PKCS8 private key
  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryDer,
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: { name: "SHA-256" },
    },
    false,
    ["sign"]
  );

  // Generate signed JWT assertion
  const jwt = await create(
    { alg: "RS256", typ: "JWT" },
    {
      iss: clientEmail,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      exp: getNumericDate(3600),
      iat: getNumericDate(0),
    },
    cryptoKey
  );

  // Exchange JWT assertion for OAuth2 access token
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`Failed to exchange Google OAuth2 token: ${errText}`);
  }

  const data = await res.json();
  return data.access_token;
}
