// onTaskWritten decides who gets which push when a task changes. Runs with
// Firebase modules stubbed out, so it checks the decisions, not delivery.
const {test, beforeEach} = require("node:test");
const assert = require("node:assert");
const Module = require("node:module");

const sent = [];
let handler;
const stubs = {
  "firebase-functions/v2/firestore": {onDocumentWritten: (_p, h) => (handler = h)},
  "firebase-functions": {logger: {error() {}}},
  "firebase-admin/app": {initializeApp() {}},
  "firebase-admin/firestore": {getFirestore: () => ({})},
  "./children": {requireChildOf() {}},
  "./signin": {},
  "./reminders": {},
  "./push": {sendToUser: async (uid, m) => sent.push({to: uid,
    title: m.notification?.title, action: m.data?.action})},
};
const load = Module._load;
Module._load = (request, ...rest) => stubs[request] ?? load(request, ...rest);
require("../index");
Module._load = load;

const snap = (d) => ({exists: !!d, data: () => d});
const task = (deps, extra = {}) => ({parent: "mom", parentName: "Mom", name: "Dishes",
  date: "11/2/2026", time: "6:00 PM", dependent: deps, ...extra});
const sam = (status) => ({dep: "sam", depName: "Sam", status});
const ali = (status) => ({dep: "ali", depName: "Ali", status});
const done = (ms) => ({lastCompletion: {dep: "sam", depName: "Sam", at: {toMillis: () => ms}}});

async function write(before, after) {
  sent.length = 0;
  await handler({params: {taskId: "T"}, data: {before: snap(before), after: snap(after)}});
  return sent.map((s) => [s.to, s.action ?? null, s.title ?? null]);
}

beforeEach(() => (sent.length = 0));

test("new task: each child is notified and schedules a reminder", async () => {
  assert.deepEqual(await write(null, task([sam(false), ali(false)])), [
    ["sam", "schedule", "New task from Mom"],
    ["ali", "schedule", "New task from Mom"],
  ]);
});

test("due time edited: silent reschedule; other edits: nothing", async () => {
  assert.deepEqual(await write(task([sam(false)]), task([sam(false)], {time: "7:00 PM"})),
    [["sam", "schedule", null]]);
  assert.deepEqual(await write(task([sam(false)]), task([sam(false)], {priority: 2})), []);
});

test("completion cancels the reminder and tells the parent", async () => {
  assert.deepEqual(await write(task([sam(false)]), task([sam(true)], done(1))), [
    ["sam", "cancel", null],
    ["mom", null, "Sam finished a task"],
  ]);
});

test("unassigned or deleted: reminder cancelled", async () => {
  assert.deepEqual(await write(task([sam(false), ali(false)]), task([sam(false)])),
    [["ali", "cancel", null]]);
  assert.deepEqual(await write(task([ali(false)]), null), [["ali", "cancel", null]]);
});

test("take turns: handover says 'Your turn'", async () => {
  const turns = {repeat: "asNeeded", date: "", time: "", rotation: ["sam", "ali"]};
  assert.deepEqual(await write(task([sam(false)], turns), task([ali(false)], {...turns, ...done(3)})), [
    ["sam", "cancel", null],
    ["ali", "schedule", "Your turn: Dishes"],
    ["mom", null, "Sam finished a task"],
  ]);
});
