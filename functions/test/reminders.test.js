const {test, beforeEach} = require("node:test");
const assert = require("node:assert");
const {Timestamp} = require("firebase-admin/firestore");
const {db, clearAll, dep} = require("./helpers");
const {runReminders} = require("../reminders");

const NOW = Date.UTC(2026, 10, 2, 18, 0); // 6:00 PM
const min = (n) => n * 60 * 1000;

function task(id, dueMs, extra = {}) {
  return db.collection("tasks").doc(id).set({
    parent: "mom", name: id, dueAt: Timestamp.fromMillis(dueMs),
    dependent: [dep("sam")], dependentIds: ["sam"], remindBefore: 0, ...extra,
  });
}

async function run(now) {
  const sent = [];
  const fake = async (uid, msg, field) => sent.push({uid, title: msg.notification.title, field});
  await runReminders(now, fake);
  return sent;
}

beforeEach(async () => {
  await clearAll();
  await db.doc("meta/reminders").set({lastRun: Timestamp.fromMillis(NOW - min(1))});
});

test("sends the due-time reminder in its minute, to iOS tokens", async () => {
  await task("Dishes", NOW - 30 * 1000);
  assert.deepEqual(await run(NOW),
    [{uid: "sam", title: "Time to: Dishes", field: "iosTokens"}]);
  // Next minute: already sent, nothing new
  assert.deepEqual(await run(NOW + min(1)), []);
});

test("sends early reminders at due minus remindBefore", async () => {
  await task("Bath", NOW + min(15) - 1000, {remindBefore: 15});
  assert.deepEqual((await run(NOW)).map((s) => s.title), ["Coming up: Bath"]);
});

test("skips children who already finished, and future tasks", async () => {
  await task("Done", NOW - 1000, {dependent: [dep("sam", true), dep("ali")]});
  await task("Later", NOW + min(5));
  assert.deepEqual(await run(NOW), [{uid: "ali", title: "Time to: Done", field: "iosTokens"}]);
});

test("catches up after a gap, but not more than 10 minutes", async () => {
  await db.doc("meta/reminders").set({lastRun: Timestamp.fromMillis(NOW - min(60))});
  await task("Recent", NOW - min(5));
  await task("Stale", NOW - min(30));
  assert.deepEqual((await run(NOW)).map((s) => s.title), ["Time to: Recent"]);
});

test("stamps a heartbeat for the iOS app", async () => {
  await run(NOW);
  const meta = (await db.doc("meta/reminders").get()).data();
  assert.equal(meta.heartbeat.toMillis(), NOW);
});
