// Sends pushes when tasks change:
//  - child newly assigned an incomplete task -> visible notification + schedule reminder
//  - task edited (name/due changed)          -> silent message, child's phone reschedules
//  - child completes / unassigned / deleted  -> silent message, child's phone cancels
//  - child completes                         -> visible notification to the parent
//  - repeating task rolls over                -> silent message, reminder moves to next date
//  - turn-taking task handed to the next child -> "Your turn" notification
// The app's side of this lives in lib/app/services/notification_service.dart.

const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {logger} = require("firebase-functions");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

// Callables for managing children (password reset, removal, account deletion)
const {requireChildOf, ...children} = require("./children");
Object.assign(exports, children);
// One-time QR / code sign-in for children's phones
Object.assign(exports, require("./signin"));
// Server-sent due-time reminders for iPhones
exports.sendDueReminders = require("./reminders").sendDueReminders;

const {sendToUser} = require("./push");

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
      // A turn-taking task handed over on completion vs. a brand-new assignment
      const handedOver = before && (after.rotation ?? []).includes(uid);
      const due = after.date || after.time ?
        `due ${after.time}, ${after.date}` : "whenever it's needed";
      sends.push(sendToUser(uid, {
        notification: {
          title: handedOver ?
            `Your turn: ${after.name}` :
            `New task from ${after.parentName ?? "your parent"}`,
          body: handedOver ? `Your turn is up · ${due}` : `${after.name} · ${due}`,
        },
        data: taskData("schedule", taskId, after),
      }));
    } else if (dueChanged(before, after)) {
      sends.push(sendToUser(uid, {data: taskData("schedule", taskId, after)}));
    }

  }

  // The app stamps lastCompletion on every check-off. Watching it (instead of
  // status flips) also catches repeating tasks, which reset to not-done.
  const doneAt = (task) => task?.lastCompletion?.at?.toMillis?.();
  if (after?.parent && doneAt(after) && doneAt(after) !== doneAt(before)) {
    const rolled = after.date !== before?.date;
    sends.push(sendToUser(after.parent, {
      notification: {
        title: `${after.lastCompletion.depName ?? "Your child"} finished a task`,
        body: rolled ? `${after.name} · next: ${after.date}` : after.name,
      },
    }));
  }

  const results = await Promise.allSettled(sends);
  results.filter((r) => r.status === "rejected")
    .forEach((r) => logger.error("Push failed", r.reason));
});
