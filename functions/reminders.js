// iPhones hold back silent pushes, so a due time changed by a parent may not
// reach an iPhone's on-device reminder in time. Instead, this job sends the
// reminders to iOS devices itself, every minute.
//
// It also stamps meta/reminders.heartbeat; the iOS app relies on these pushes
// only while that heartbeat is recent, and otherwise keeps scheduling its own
// local reminders (e.g. if the functions aren't deployed).

const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");
const {sendToUser} = require("./push");

const db = getFirestore();
const MAX_EARLY_MIN = 60; // longest "remind me before" option
const MAX_CATCH_UP_MS = 10 * 60 * 1000;

// Reminders that fall in (from, to]: the due-time one and the early one.
function remindersBetween(task, from, to) {
  const due = task.dueAt?.toMillis?.();
  if (!due) return [];
  const out = [];
  if (due > from && due <= to) {
    out.push({title: `Time to: ${task.name}`,
      body: "Tap to open RemindMi and check it off"});
  }
  const before = task.remindBefore ?? 0;
  const early = due - before * 60 * 1000;
  if (before > 0 && early > from && early <= to) {
    out.push({title: `Coming up: ${task.name}`,
      body: before % 60 === 0 ?
        `Due in ${before / 60} hour${before === 60 ? "" : "s"}` :
        `Due in ${before} minutes`});
  }
  return out;
}

// Sends every reminder due since the last run. `send` is injectable for tests.
async function runReminders(now = Date.now(), send = sendToUser) {
  const meta = db.doc("meta/reminders");
  const last = (await meta.get()).get("lastRun")?.toMillis?.() ?? now - 60 * 1000;
  // After an outage, don't spam reminders that are long past
  const from = Math.max(last, now - MAX_CATCH_UP_MS);

  const tasks = await db.collection("tasks")
    .where("dueAt", ">", Timestamp.fromMillis(from))
    .where("dueAt", "<=", Timestamp.fromMillis(now + MAX_EARLY_MIN * 60 * 1000))
    .get();

  const sends = [];
  for (const doc of tasks.docs) {
    const task = doc.data();
    for (const reminder of remindersBetween(task, from, now)) {
      for (const d of task.dependent ?? []) {
        if (d.status) continue;
        sends.push(send(d.dep,
          {notification: reminder, data: {taskId: doc.id}}, "iosTokens"));
      }
    }
  }
  const results = await Promise.allSettled(sends);
  results.filter((r) => r.status === "rejected")
    .forEach((r) => logger.error("Reminder push failed", r.reason));

  const stamp = Timestamp.fromMillis(now);
  await meta.set({lastRun: stamp, heartbeat: stamp});
  return sends.length;
}

exports.runReminders = runReminders;
exports.sendDueReminders = onSchedule("every 1 minutes", () => runReminders());
