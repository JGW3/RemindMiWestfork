// One-time sign-in codes, so a parent can sign a child's phone in without
// anyone typing a password: the parent's app shows a QR code / 8-character
// code, and the child's app swaps it for a Firebase custom token.
//
// In production, minting custom tokens needs the functions' service account
// to have the "Service Account Token Creator" role (see README).

const crypto = require("node:crypto");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");
const {requireChildOf} = require("./children");

const db = getFirestore();
const codes = db.collection("signInCodes"); // no client access (see rules)
const ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // no 0/O or 1/I
const TTL_MS = 10 * 60 * 1000;

const normalize = (code) =>
  String(code ?? "").toUpperCase().replace(/^REMINDMI:/, "").replace(/[^A-Z0-9]/g, "");

exports.createSignInCode = onCall(async (request) => {
  const {parent, childUid} = await requireChildOf(request);

  // Only the newest code for a child works
  const old = await codes.where("child", "==", childUid).get();
  const batch = db.batch();
  old.docs.forEach((doc) => batch.delete(doc.ref));

  const code = Array.from({length: 8},
    () => ALPHABET[crypto.randomInt(ALPHABET.length)]).join("");
  const expiresAt = Timestamp.fromMillis(Date.now() + TTL_MS);
  batch.set(codes.doc(code), {child: childUid, parent, expiresAt});
  await batch.commit();
  return {code, expiresAt: expiresAt.toMillis()};
});

exports.redeemSignInCode = onCall(async (request) => {
  const code = normalize(request.data?.code);
  if (code.length !== 8) {
    throw new HttpsError("invalid-argument", "Codes are 8 letters and numbers.");
  }
  const child = await db.runTransaction(async (tx) => {
    const ref = codes.doc(code);
    const snap = await tx.get(ref);
    if (!snap.exists || snap.get("expiresAt").toMillis() < Date.now()) {
      if (snap.exists) tx.delete(ref);
      return null;
    }
    tx.delete(ref); // single use
    return snap.get("child");
  });
  if (!child) {
    throw new HttpsError("not-found", "That code is wrong or has expired.");
  }
  return {token: await getAuth().createCustomToken(child)};
});
