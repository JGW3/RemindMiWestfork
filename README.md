# RemindMi (JGW3 fork)

A family to-do / reminder app. A **parent** account creates **child** (dependent) accounts, assigns them tasks, and watches them get checked off. Children sign in on their own device, see only their own tasks, and tap to mark them done.

This fork started from a Software Engineering group project ([dderheim00/RemindMi](https://github.com/dderheim00/RemindMi)) that never actually worked end to end. The fixes are listed under [What was broken](#what-was-broken).

## How it works

| | Parent | Child |
|---|---|---|
| Account | Signs up from the app | Created by the parent (Manage → Add dependent) |
| Tasks | Create, edit, delete, assign to one or more children | Sees only tasks assigned to them |
| Completion | Sees each child's status per task | Taps the checkbox, or opens the task and hits **Completed** |
| Home tabs | Incomplete / Completed | Incomplete / Completed |

A task shows as **Completed** for the parent once every assigned child has finished it.

## Setup

### Prerequisites

- Flutter 3.32+ (Dart 3.8+)
- A Firebase project with **Email/Password** auth and **Cloud Firestore** turned on
- The [Firebase CLI](https://firebase.google.com/docs/cli) to deploy the security rules

### 1. Get the code

```bash
git clone https://github.com/JGW3/RemindMiWestfork.git
cd RemindMiWestfork
flutter pub get
```

### 2. Connect Firebase

**Android:** `android/app/google-services.json` is already set up for the `remindmi-dde76` project (package `com.example.reminder`). To use a different project, register an Android app with that package name and replace the file.

**iOS:** not configured. There's no `GoogleService-Info.plist`, so the app will crash on launch on iOS until you add one. The easiest fix is:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Deploy the Firestore rules

The rules in `firestore.rules` scope every read and write to the family it belongs to. The app's queries are written to match them, so the app won't work against a locked-down database until the rules are deployed:

```bash
firebase login
firebase use remindmi-dde76   # or your project id
firebase deploy --only firestore:rules
```

### 4. Run

```bash
flutter run
```

### First run walkthrough

1. Sign up as a parent, then log in.
2. **Manage → Add dependent**: create a child with their own email and password. You stay signed in as the parent.
3. **+** on the home screen: create a task and tick the child(ren) it's for.
4. On another device or emulator, log in as the child. The task appears under Incomplete; check it off.
5. Back on the parent device it moves to Completed, live.

## Data model (Firestore)

```
users/{uid}
  fullName, email
  role:    'parent' | 'dependent'
  parent:  parent uid ('' for parents)

tasks/{taskId}
  parent, parentName
  name, description, date, time
  priority:      1 = High, 2 = Medium, 3 = Low
  dependent:     [{ dep: uid, depName, status: bool }]
  dependentIds:  [uid]   // mirror of dependent[].dep, used for querying and rules
```

## What was broken

- **Login didn't save the session where the app looked for it.** Login wrote `user_id` / `user_name` / `user_type`, but every screen reads `id` / `fullName` / `role`. After logging in, the app had no user id, no role, and no tasks, and it went back to the landing page on every restart.
- **Adding a child logged the parent out.** `createUserWithEmailAndPassword` on the main Firebase Auth instance switches the session to the new user. Children are now created through a temporary secondary Firebase app.
- **Children's queries read the entire `tasks` collection** and filtered on the device, which leaks every family's tasks and fails under any real security rules. Tasks now carry `dependentIds`, and children query with `arrayContains`.
- **`where` + `orderBy` queries needed composite indexes** that were never created, so the parent lists errored silently. Sorting now happens on the device.
- **Completing a task rewrote the whole document** from possibly stale data. It now updates only the completion list, inside a transaction, so two children finishing at the same time don't overwrite each other.
- **Sign out didn't sign out of Firebase**, and the splash screen trusted cached data even when there was no Firebase session.
- Login now handles the newer `invalid-credential` error and no longer gets stuck on the loading spinner after a non-auth error.
- No security rules existed. `firestore.rules` now enforces them.

## Known gaps / next steps

- **No actual reminders yet.** Tasks have a date and time, but nothing fires a notification. That would need `flutter_local_notifications` on the child's device, or FCM triggered from a Cloud Function.
- Date and time are stored as display strings, not timestamps, so you can't sort by due date or detect overdue tasks.
- Children can't be edited or removed from the app yet ("Edit profile" and "Delete profile" are placeholders).
- Tasks created before this fork don't have `dependentIds`, so children won't see them. Re-save them from the parent's edit screen.

## Tech stack

Flutter · GetX (state and routing) · Firebase Auth · Cloud Firestore · GetStorage

## License

MIT
