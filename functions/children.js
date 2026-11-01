// Callable functions for things the client SDK can't do on someone else's
// account: resetting a child's password, removing a child completely, and
// deleting a parent's whole family account.

const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore} = require("firebase-admin/firestore");

const db = getFirestore();

// Resolves the caller and checks `childUid` is one of their children.
async function requireChildOf(request) {
  const parent = request.auth?.uid;
  if (!parent) throw new HttpsError("unauthenticated", "Sign in first.");
  const childUid = request.data?.childUid;
  if (typeof childUid !== "string" || !childUid) {
    throw new HttpsError("invalid-argument", "childUid is required.");
  }
  const child = await db.collection("users").doc(childUid).get();
  if (!child.exists || child.get("parent") !== parent ||
      child.get("role") !== "dependent") {
    throw new HttpsError("permission-denied", "That isn't one of your children.");
  }
  return {parent, childUid};
}

async function deleteAuthUser(uid) {
  try {
    await getAuth().deleteUser(uid);
  } catch (e) {
    if (e.code !== "auth/user-not-found") throw e;
  }
}

// Takes a child off every task of `parent`. Turn-taking tasks they were
// holding pass to the next child in line; tasks left with nobody are deleted.
async function removeFromTasks(parent, childUid, batch) {
  const [holding, inRotation] = await Promise.all([
    db.collection("tasks").where("dependentIds", "array-contains", childUid).get(),
    db.collection("tasks").where("rotation", "array-contains", childUid).get(),
  ]);
  const docs = new Map();
  for (const doc of [...holding.docs, ...inRotation.docs]) {
    if (doc.get("parent") === parent) docs.set(doc.id, doc);
  }

  for (const doc of docs.values()) {
    const task = doc.data();
    const oldRotation = task.rotation ?? [];
    const rotation = oldRotation.filter((id) => id !== childUid);
    let dependent = (task.dependent ?? []).filter((d) => d.dep !== childUid);

    const wasHolder = (task.dependentIds ?? []).includes(childUid);
    if (wasHolder && oldRotation.length > 1 && rotation.length > 0) {
      const at = oldRotation.indexOf(childUid);
      const nextId = oldRotation[(at + 1) % oldRotation.length];
      const next = await db.collection("users").doc(nextId).get();
      dependent = [{dep: nextId, depName: next.get("fullName") ?? "", status: false}];
    }

    if (dependent.length === 0) {
      batch.delete(doc.ref);
    } else {
      batch.update(doc.ref, {
        dependent,
        dependentIds: dependent.map((d) => d.dep),
        rotation: rotation.length > 1 ? rotation : [],
      });
    }
  }
}

exports.requireChildOf = requireChildOf;

exports.setChildPassword = onCall(async (request) => {
  const {childUid} = await requireChildOf(request);
  const password = request.data?.password;
  if (typeof password !== "string" || password.length < 6) {
    throw new HttpsError("invalid-argument",
      "The password needs at least 6 characters.");
  }
  await getAuth().updateUser(childUid, {password});
  return {ok: true};
});

exports.deleteChild = onCall(async (request) => {
  const {parent, childUid} = await requireChildOf(request);
  const batch = db.batch();
  await removeFromTasks(parent, childUid, batch);
  batch.delete(db.collection("users").doc(childUid));
  await batch.commit();
  await deleteAuthUser(childUid);
  return {ok: true};
});

// Deletes the caller's account. For a parent that means the whole family:
// every child account and every task they created.
exports.deleteMyAccount = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Sign in first.");
  const me = await db.collection("users").doc(uid).get();

  if (me.get("role") === "dependent") {
    const batch = db.batch();
    await removeFromTasks(me.get("parent"), uid, batch);
    batch.delete(me.ref);
    await batch.commit();
    await deleteAuthUser(uid);
    return {ok: true};
  }

  const [children, tasks] = await Promise.all([
    db.collection("users").where("parent", "==", uid).get(),
    db.collection("tasks").where("parent", "==", uid).get(),
  ]);
  const refs = [...children.docs, ...tasks.docs].map((d) => d.ref);
  refs.push(me.ref);
  // Firestore batches are capped at 500 writes
  for (let i = 0; i < refs.length; i += 450) {
    const batch = db.batch();
    refs.slice(i, i + 450).forEach((ref) => batch.delete(ref));
    await batch.commit();
  }
  for (const child of children.docs) await deleteAuthUser(child.id);
  await deleteAuthUser(uid);
  return {ok: true};
});
