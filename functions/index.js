// Sends pushes when tasks change:
//  - child newly assigned an incomplete task -> visible notification + schedule reminder
//  - task edited (name/due changed)          -> silent message, child's phone reschedules
//  - child completes / unassigned / deleted  -> silent message, child's phone cancels
//  - child completes                         -> visible notification to the parent
// The app's side of this lives in lib/app/services/notification_service.dart.

const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {logger} = require("firebase-functions");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();

const statusByDep = (task) =>
  new Map((task?.dependent ?? []).map((d) => [d.dep, d]));

const dueChanged = (before, after) =>
  before.name !== after.name ||
  before.date !== after.date ||
  before.time !== after.time ||
  (before.remindBefore ?? 0) !== (after.remindBefore ?? 0) ||
  before.dueAt?.toMillis?.() !== after.dueAt?.toMillis?.();

// FCM data values must all be strings.
function taskData(action, taskId, task) {
  const data = {action, taskId};
  if (action === "schedule") {
    data.name = task.name ?? "";
    data.date = task.date ?? "";
    data.time = task.time ?? "";
    data.remindBefore = String(task.remindBefore ?? 0);
    if (task.dueAt) data.dueAt = String(task.dueAt.toMillis());
  }
  return data;
}

async function sendToUser(uid, {notification, data}) {
  const userRef = db.collection("users").doc(uid);
  const user = await userRef.get();
  const tokens = user.get("fcmTokens") ?? [];
  if (tokens.length === 0) return;

  const message = {tokens, data: data ?? {}};
  if (notification) {
    message.notification = notification;
    message.android = {priority: "high"};
  } else {
    // Silent: wake the app in the background so it can update its reminder.
    message.android = {priority: "high"};
    message.apns = {
      headers: {"apns-push-type": "background", "apns-priority": "5"},
      payload: {aps: {"content-available": 1}},
    };
  }

  const res = await getMessaging().sendEachForMulticast(message);
  const dead = res.responses
    .map((r, i) => (!r.success &&
      ["messaging/registration-token-not-registered",
        "messaging/invalid-registration-token"].includes(r.error?.code) ?
      tokens[i] : null))
    .filter(Boolean);
  if (dead.length) {
    await userRef.update({fcmTokens: FieldValue.arrayRemove(...dead)});
  }
}

exports.onTaskWritten = onDocumentWritten("tasks/{taskId}", async (event) => {
  const taskId = event.params.taskId;
  const before = event.data.before.exists ? event.data.before.data() : null;
  const after = event.data.after.exists ? event.data.after.data() : null;
  const beforeDeps = statusByDep(before);
  const afterDeps = statusByDep(after);
  const sends = [];

  for (const uid of new Set([...beforeDeps.keys(), ...afterDeps.keys()])) {
    const was = beforeDeps.get(uid);
    const now = afterDeps.get(uid);
    const pendingBefore = was && !was.status;
    const pendingNow = now && !now.status;

    if (!pendingNow) {
      if (pendingBefore) {
        sends.push(sendToUser(uid, {data: taskData("cancel", taskId)}));
      }
    } else if (!was) {
      sends.push(sendToUser(uid, {
        notification: {
          title: `New task from ${after.parentName ?? "your parent"}`,
          body: `${after.name} · due ${after.time}, ${after.date}`,
        },
        data: taskData("schedule", taskId, after),
      }));
    } else if (dueChanged(before, after)) {
      sends.push(sendToUser(uid, {data: taskData("schedule", taskId, after)}));
    }

    if (pendingBefore && now?.status === true && after?.parent) {
      sends.push(sendToUser(after.parent, {
        notification: {
          title: `${now.depName ?? "Your child"} finished a task`,
          body: after.name,
        },
      }));
    }
  }

  const results = await Promise.allSettled(sends);
  results.filter((r) => r.status === "rejected")
    .forEach((r) => logger.error("Push failed", r.reason));
});
