const {test, before, beforeEach, after} = require("node:test");
const fs = require("node:fs");
const path = require("node:path");
const {initializeTestEnvironment, assertSucceeds, assertFails} =
  require("@firebase/rules-unit-testing");
const {doc, getDoc, setDoc, updateDoc, collection, query, where, getDocs} =
  require("firebase/firestore");
const {PROJECT, clearAll, seedFamily, dep, db} = require("./helpers");

let env;
const as = (uid) => env.authenticatedContext(uid).firestore();

before(async () => {
  const [host, port] = process.env.FIRESTORE_EMULATOR_HOST.split(":");
  env = await initializeTestEnvironment({
    projectId: PROJECT,
    firestore: {
      host, port: Number(port),
      rules: fs.readFileSync(path.join(__dirname, "../../firestore.rules"), "utf8"),
    },
  });
});
after(() => env.cleanup());

beforeEach(async () => {
  await clearAll();
  await seedFamily();
  await db.collection("tasks").doc("dishes").set({
    parent: "mom", parentName: "Mom", name: "Dishes", description: "",
    date: "11/2/2026", time: "6:00 PM", priority: 1,
    dependent: [dep("sam")], dependentIds: ["sam"], repeat: "none", rotation: [],
  });
  await db.collection("tasks").doc("litter").set({
    parent: "mom", parentName: "Mom", name: "Litter", description: "",
    date: "11/2/2026", time: "6:00 PM", priority: 1,
    dependent: [dep("sam")], dependentIds: ["sam"],
    repeat: "daily", rotation: ["sam", "ali"],
  });
});

test("parents can sign up as parents, not as children", async () => {
  await assertSucceeds(setDoc(doc(as("new"), "users/new"),
    {fullName: "N", email: "n@x", role: "parent", parent: ""}));
  await assertFails(setDoc(doc(as("new2"), "users/new2"),
    {fullName: "N", email: "n@x", role: "dependent", parent: "mom"}));
});

test("family members can see each other; strangers can't", async () => {
  await assertSucceeds(getDoc(doc(as("sam"), "users/mom")));
  await assertSucceeds(getDoc(doc(as("sam"), "users/ali")));
  await assertSucceeds(getDocs(query(collection(as("sam"), "users"),
    where("parent", "==", "mom"))));
  await assertSucceeds(getDoc(doc(as("mom"), "users/sam")));
  await assertFails(getDoc(doc(as("eve"), "users/sam")));
  await assertFails(getDoc(doc(as("sam"), "users/eve")));
});

test("avatars: self and parent can change a child's; siblings can't", async () => {
  const avatar = {avatar: {emoji: "🦊", color: 1}};
  await assertSucceeds(updateDoc(doc(as("sam"), "users/sam"), avatar));
  await assertSucceeds(updateDoc(doc(as("mom"), "users/sam"), avatar));
  await assertSucceeds(updateDoc(doc(as("mom"), "users/sam"), {fullName: "Samuel"}));
  await assertFails(updateDoc(doc(as("ali"), "users/sam"), avatar));
  await assertFails(updateDoc(doc(as("mom"), "users/sam"), {role: "parent"}));
  await assertFails(updateDoc(doc(as("sam"), "users/sam"), {parent: "eve"}));
});

test("tasks are visible to the parent and assignee only", async () => {
  await assertSucceeds(getDoc(doc(as("sam"), "tasks/dishes")));
  await assertSucceeds(getDoc(doc(as("mom"), "tasks/dishes")));
  await assertFails(getDoc(doc(as("ali"), "tasks/dishes")));
  await assertFails(getDoc(doc(as("eve"), "tasks/dishes")));
  await assertSucceeds(getDocs(query(collection(as("sam"), "tasks"),
    where("dependentIds", "array-contains", "sam"))));
  await assertSucceeds(getDocs(query(collection(as("mom"), "tasks"),
    where("parent", "==", "mom"))));
});

test("children can check tasks off but not edit them", async () => {
  const ref = doc(as("sam"), "tasks/dishes");
  await assertSucceeds(updateDoc(ref, {dependent: [dep("sam", true)],
    lastCompletion: {dep: "sam", depName: "Sam"}, history: []}));
  await assertFails(updateDoc(ref, {name: "No dishes"}));
  // Not repeating, so the due date can't move
  await assertFails(updateDoc(ref, {date: "12/1/2026"}));
});

test("turn-taking hands over only within the rotation", async () => {
  const ref = doc(as("sam"), "tasks/litter");
  await assertFails(updateDoc(ref, {dependent: [{dep: "eve", depName: "Eve", status: false}],
    dependentIds: ["eve"]}));
  await assertSucceeds(updateDoc(ref, {dependent: [dep("ali")], dependentIds: ["ali"],
    date: "11/3/2026"}));
});

test("parents can't give tasks to another family", async () => {
  await assertFails(updateDoc(doc(as("mom"), "tasks/dishes"), {parent: "eve"}));
  await assertFails(setDoc(doc(as("eve"), "tasks/sneaky"), {parent: "mom"}));
});
