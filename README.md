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

A task shows as **Completed** for the parent once every assigned child has finished it. Lists are sorted by due time (then priority), and unfinished tasks past their due time get a red **Overdue** tag.

### Reminders and notifications

- **Due-time reminder (child's phone):** each incomplete task gets a local notification at its due time, plus an optional early one (5, 15, 30 or 60 minutes before, picked per task). These work offline and survive reboots, and they stay in step with the task list whenever the app is open.
- **New task (child):** a push notification arrives as soon as a parent assigns a task, and the reminder is scheduled even if the app is closed.
- **Task edited / completed / removed:** a silent push updates or cancels the reminder on the child's phone.
- **Task done (parent):** a push notification when a child checks something off.

Local reminders work on their own. The pushes need the Cloud Function in `functions/` deployed (see step 4).

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

### 4. Deploy the push-notification function (optional)

Cloud Functions require the Firebase **Blaze** (pay-as-you-go) plan. A family's usage stays well inside the free tier, but a billing account has to be attached. Skip this step and everything works except the pushes.

```bash
cd functions && npm install && cd ..
firebase deploy --only functions
```

**iOS push** additionally needs an APNs key uploaded under Firebase console → Project settings → Cloud Messaging, plus the *Push Notifications* capability enabled for the Runner target in Xcode. Background mode `remote-notification` is already in `Info.plist`.

### 5. Run

```bash
flutter run
flutter test   # due-date parsing tests
```

On Android 12+, the app asks for the "Alarms & reminders" permission so reminders fire on time. If it's denied, reminders still fire, but Android may delay them by a few minutes.

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
  fcmTokens: [push token per signed-in device]

tasks/{taskId}
  parent, parentName
  name, description, date, time
  dueAt:         Timestamp (exact due moment; date/time are display strings)
  remindBefore:  minutes before dueAt for an early reminder (0 = none)
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

- No repeating tasks (daily / weekdays / weekly) yet.
- The Overdue tag appears the next time the list redraws, not the exact moment the due time passes.
- iOS treats silent pushes as low priority, so an edited due time may not reach an iPhone until the child opens the app.
- Tested so far: `flutter analyze` and unit tests only. Not yet run on a real device.
- Children can't be edited or removed from the app yet ("Edit profile" and "Delete profile" are placeholders).

## Tech stack

Flutter · GetX (state and routing) · Firebase Auth · Cloud Firestore · GetStorage

## License

MIT
