const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNoticeNotification = functions.firestore
  .document("notices/{noticeId}")
  .onCreate(async (snap, context) => {
    const newValue = snap.data();
    const title = newValue.title;
    const description = newValue.description;

    // Fetch all users to get their FCM tokens
    const usersSnapshot = await admin.firestore().collection("users").get();
    const tokens = [];
    
    usersSnapshot.forEach((doc) => {
      const user = doc.data();
      if (user.fcmToken) {
        tokens.push(user.fcmToken);
      }
    });

    if (tokens.length === 0) {
      console.log("No users with FCM tokens found.");
      return null;
    }

    const payload = {
      notification: {
        title: title,
        body: description,
      },
      tokens: tokens,
    };

    // Send notifications to all tokens.
    try {
      const response = await admin.messaging().sendMulticast(payload);
      console.log(response.successCount + " messages were sent successfully");
      return response;
    } catch (error) {
      console.error("Error sending message:", error);
      return null;
    }
  });
