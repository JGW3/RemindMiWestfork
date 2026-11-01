// Shared setup for tests run inside `npm test` (Firebase emulators).
const {initializeApp, getApps} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getAuth} = require("firebase-admin/auth");

const PROJECT = "demo-remindmi";
if (!getApps().length) initializeApp({projectId: PROJECT});
const db = getFirestore();
const auth = getAuth();

async function clearAll() {
  const host = process.env.FIRESTORE_EMULATOR_HOST;
  await fetch(`http://${host}/emulator/v1/projects/${PROJECT}/databases/(default)/documents`,
    {method: "DELETE"});
  await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/emulator/v1/projects/${PROJECT}/accounts`,
    {method: "DELETE"});
}

// A parent with two children, written with admin rights (bypasses rules).
async function seedFamily() {
  const users = {
    mom: {fullName: "Mom", email: "mom@x.test", role: "parent", parent: ""},
    sam: {fullName: "Sam", email: "sam@x.test", role: "dependent", parent: "mom"},
    ali: {fullName: "Ali", email: "ali@x.test", role: "dependent", parent: "mom"},
    eve: {fullName: "Eve", email: "eve@x.test", role: "parent", parent: ""},
  };
  for (const [uid, data] of Object.entries(users)) {
    await auth.createUser({uid, email: data.email, password: "Passw0rd!"});
    await db.collection("users").doc(uid).set(data);
  }
  return users;
}

const dep = (id, status = false) =>
  ({dep: id, depName: id === "sam" ? "Sam" : "Ali", status});

module.exports = {PROJECT, db, auth, clearAll, seedFamily, dep};
