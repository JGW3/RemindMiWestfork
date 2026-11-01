const {test, beforeEach} = require("node:test");
const assert = require("node:assert");
const {initializeApp} = require("firebase/app");
const {getAuth, connectAuthEmulator, signInWithEmailAndPassword, signOut} =
  require("firebase/auth");
const {getFunctions, connectFunctionsEmulator, httpsCallable} =
  require("firebase/functions");
const {db, auth, clearAll, seedFamily, dep} = require("./helpers");

const app = initializeApp({projectId: "demo-remindmi", apiKey: "fake"});
const clientAuth = getAuth(app);
connectAuthEmulator(clientAuth, `http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}`,
  {disableWarnings: true});
const functions = getFunctions(app);
const [fnHost, fnPort] = (process.env.FUNCTIONS_EMULATOR_HOST ?? "127.0.0.1:5101").split(":");
connectFunctionsEmulator(functions, fnHost, Number(fnPort));

async function callAs(email, name, data) {
  await signInWithEmailAndPassword(clientAuth, email, "Passw0rd!");
  try {
    return await httpsCallable(functions, name)(data);
  } finally {
    await signOut(clientAuth);
  }
}

beforeEach(async () => {
  await clearAll();
  await seedFamily();
  const base = {parent: "mom", parentName: "Mom", description: "", date: "",
    time: "", priority: 1, repeat: "none", rotation: []};
  await db.collection("tasks").doc("solo").set({...base, name: "Solo",
    dependent: [dep("sam")], dependentIds: ["sam"]});
  await db.collection("tasks").doc("both").set({...base, name: "Both",
    dependent: [dep("sam"), dep("ali")], dependentIds: ["sam", "ali"]});
  await db.collection("tasks").doc("turns").set({...base, name: "Turns",
    repeat: "asNeeded", rotation: ["sam", "ali"],
    dependent: [dep("sam")], dependentIds: ["sam"]});
});

test("deleteChild removes the child everywhere", async () => {
  await callAs("mom@x.test", "deleteChild", {childUid: "sam"});

  assert.equal((await db.doc("tasks/solo").get()).exists, false);
  const both = (await db.doc("tasks/both").get()).data();
  assert.deepEqual(both.dependentIds, ["ali"]);
  const turns = (await db.doc("tasks/turns").get()).data();
  assert.deepEqual(turns.dependentIds, ["ali"], "turn passes to the next child");
  assert.deepEqual(turns.rotation, [], "a rotation of one is no rotation");
  assert.equal((await db.doc("users/sam").get()).exists, false);
  await assert.rejects(auth.getUser("sam"));
});

test("only the child's own parent can remove or reset them", async () => {
  await assert.rejects(callAs("eve@x.test", "deleteChild", {childUid: "sam"}),
    /permission-denied|isn't one of your children/);
  await assert.rejects(callAs("ali@x.test", "setChildPassword",
    {childUid: "sam", password: "whatever1"}), /isn't one of your children/);
  assert.equal((await db.doc("users/sam").get()).exists, true);
});

test("setChildPassword changes the child's password", async () => {
  await callAs("mom@x.test", "setChildPassword", {childUid: "sam", password: "NewPass1!"});
  await signInWithEmailAndPassword(clientAuth, "sam@x.test", "NewPass1!");
  await signOut(clientAuth);
  await assert.rejects(callAs("mom@x.test", "setChildPassword",
    {childUid: "sam", password: "123"}), /at least 6/);
});

test("deleteMyAccount as a parent deletes the whole family", async () => {
  await callAs("mom@x.test", "deleteMyAccount", {});
  for (const uid of ["mom", "sam", "ali"]) {
    assert.equal((await db.doc(`users/${uid}`).get()).exists, false, uid);
    await assert.rejects(auth.getUser(uid));
  }
  assert.equal((await db.collection("tasks").get()).size, 0);
  assert.equal((await db.doc("users/eve").get()).exists, true, "other families untouched");
});
