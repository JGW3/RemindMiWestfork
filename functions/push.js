const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

const db = getFirestore();
const DEAD = ["messaging/registration-token-not-registered",
  "messaging/invalid-registration-token"];

// Sends to a user's devices. `tokenField` picks which list: fcmTokens (every
// device) or iosTokens (just iPhones/iPads). Without a notification the
// message is silent and just wakes the app to update its reminders.
async function sendToUser(uid, {notification, data}, tokenField = "fcmTokens") {
  const userRef = db.collection("users").doc(uid);
  const user = await userRef.get();
  const tokens = user.get(tokenField) ?? [];
  if (tokens.length === 0) return;

  const message = {tokens, data: data ?? {}};
  message.android = {priority: "high"};
  if (notification) {
    message.notification = notification;
  } else {
    message.apns = {
      headers: {"apns-push-type": "background", "apns-priority": "5"},
      payload: {aps: {"content-available": 1}},
    };
  }

  const res = await getMessaging().sendEachForMulticast(message);
  const dead = res.responses
    .map((r, i) => (!r.success && DEAD.includes(r.error?.code) ? tokens[i] : null))
    .filter(Boolean);
  if (dead.length) {
    await userRef.update({
      fcmTokens: FieldValue.arrayRemove(...dead),
      iosTokens: FieldValue.arrayRemove(...dead),
    });
  }
}

module.exports = {sendToUser};
