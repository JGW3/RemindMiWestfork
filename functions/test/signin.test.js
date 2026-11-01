const {test, beforeEach} = require("node:test");
const assert = require("node:assert");
const {initializeApp} = require("firebase/app");
const {getAuth, connectAuthEmulator, signInWithEmailAndPassword,
  signInWithCustomToken, signOut} = require("firebase/auth");
const {getFunctions, connectFunctionsEmulator, httpsCallable} =
  require("firebase/functions");
const {db, clearAll, seedFamily} = require("./helpers");

const app = initializeApp({projectId: "demo-remindmi", apiKey: "fake"}, "signin");
const clientAuth = getAuth(app);
connectAuthEmulator(clientAuth, `http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}`,
  {disableWarnings: true});
const functions = getFunctions(app);
connectFunctionsEmulator(functions, "127.0.0.1", 5101);
const call = (name, data) => httpsCallable(functions, name)(data);

async function codeFor(childUid, as = "mom@x.test") {
  await signInWithEmailAndPassword(clientAuth, as, "Passw0rd!");
  try {
    return (await call("createSignInCode", {childUid})).data;
  } finally {
    await signOut(clientAuth);
  }
}

beforeEach(async () => {
  await clearAll();
  await seedFamily();
});

test("a parent's code signs the child's phone in, once", async () => {
  const {code, expiresAt} = await codeFor("sam");
  assert.match(code, /^[A-Z2-9]{8}$/);
  assert.ok(expiresAt > Date.now());

  // Signed out (a fresh phone), using the QR payload format
  const {data} = await call("redeemSignInCode", {code: `remindmi:${code}`});
  const cred = await signInWithCustomToken(clientAuth, data.token);
  assert.equal(cred.user.uid, "sam");
  await signOut(clientAuth);

  await assert.rejects(call("redeemSignInCode", {code}), /wrong or has expired/);
});

test("typed codes ignore case and dashes", async () => {
  const {code} = await codeFor("ali");
  const typed = `${code.slice(0, 4)}-${code.slice(4)}`.toLowerCase();
  const {data} = await call("redeemSignInCode", {code: typed});
  assert.ok(data.token);
});

test("a new code replaces the old one", async () => {
  const first = (await codeFor("sam")).code;
  await codeFor("sam");
  await assert.rejects(call("redeemSignInCode", {code: first}), /wrong or has expired/);
});

test("expired codes are refused", async () => {
  const {code} = await codeFor("sam");
  await db.doc(`signInCodes/${code}`).update({expiresAt: new Date(Date.now() - 1000)});
  await assert.rejects(call("redeemSignInCode", {code}), /wrong or has expired/);
});

test("only the child's parent can make a code", async () => {
  await assert.rejects(codeFor("sam", "eve@x.test"), /isn't one of your children/);
  await assert.rejects(codeFor("ali", "sam@x.test"), /isn't one of your children/);
});
