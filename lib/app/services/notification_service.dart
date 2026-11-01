import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:remindmi/app/helper/due_date.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

// Runs in a separate isolate when a push arrives while the app is in the
// background or closed. The Cloud Function sends task details in `data`, so
// the reminder can be (re)scheduled without opening the app.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.init();
  await NotificationService.handleTaskMessage(message.data);
}

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channel = AndroidNotificationChannel(
    'reminders',
    'Task reminders',
    description: 'Reminders for tasks when they are due',
    importance: Importance.high,
  );

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Task reminders',
      channelDescription: 'Reminders for tasks when they are due',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  // Notification ids must be 32-bit ints; derive a stable one from the task id.
  static int _idFor(String taskId) {
    var hash = 0;
    for (final unit in taskId.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash;
  }

  static Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local.identifier));
    } catch (e) {
      debugPrint('Falling back to UTC for reminders: $e');
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permissions are requested after login instead of at app start
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
    _initialized = true;
  }

  static Future<void> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      await android.requestNotificationsPermission();
      if (await android.canScheduleExactNotifications() != true) {
        await android.requestExactAlarmsPermission();
      }
    }
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static int _earlyIdFor(String taskId) => _idFor('$taskId:early');

  // Schedules the due-time reminder and, if remindBefore > 0, an early one.
  static Future<void> scheduleReminder(
    String taskId,
    String name,
    DateTime dueAt, {
    int remindBefore = 0,
  }) async {
    await cancelReminder(taskId);
    await _scheduleAt(
      _idFor(taskId),
      dueAt,
      'Time to: $name',
      'Tap to open RemindMi and check it off',
      taskId,
    );
    if (remindBefore > 0) {
      await _scheduleAt(
        _earlyIdFor(taskId),
        dueAt.subtract(Duration(minutes: remindBefore)),
        'Coming up: $name',
        'Due in ${_describeMinutes(remindBefore)}',
        taskId,
      );
    }
  }

  static String _describeMinutes(int minutes) => minutes % 60 == 0
      ? '${minutes ~/ 60} hour${minutes == 60 ? '' : 's'}'
      : '$minutes minutes';

  static Future<void> _scheduleAt(
    int id,
    DateTime at,
    String title,
    String body,
    String payload,
  ) async {
    final when = tz.TZDateTime.from(at, tz.local);
    if (when.isBefore(tz.TZDateTime.now(tz.local))) return;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exact =
        android == null ||
        await android.canScheduleExactNotifications() == true;

    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      payload: payload,
    );
  }

  static Future<void> cancelReminder(String taskId) async {
    await _plugin.cancel(id: _idFor(taskId));
    await _plugin.cancel(id: _earlyIdFor(taskId));
  }

  static Future<void> cancelAll() => _plugin.cancelAllPendingNotifications();

  // Makes the scheduled reminders exactly match the child's incomplete tasks.
  static bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  // On iPhones, the server sends reminders (functions/reminders.js) because
  // iOS delays the silent pushes that would keep local ones up to date. Only
  // rely on it while its heartbeat is recent; otherwise schedule locally.
  static Future<bool> _serverSendsReminders() async {
    if (!_isIOS) return false;
    try {
      if (await FirebaseMessaging.instance.getToken() == null) return false;
      final meta = await FirebaseFirestore.instance.doc('meta/reminders').get();
      final beat = (meta.data()?['heartbeat'] as Timestamp?)?.toDate();
      return beat != null &&
          DateTime.now().difference(beat) < const Duration(minutes: 10);
    } catch (_) {
      return false;
    }
  }

  static Future<void> syncReminders(List<Task> incompleteTasks) async {
    await init();
    if (await _serverSendsReminders()) {
      await cancelAll();
      return;
    }
    final wanted = {
      for (final task in incompleteTasks) ...[
        _idFor(task.id),
        _earlyIdFor(task.id),
      ],
    };
    for (final pending in await _plugin.pendingNotificationRequests()) {
      if (!wanted.contains(pending.id)) {
        await _plugin.cancel(id: pending.id);
      }
    }
    for (final task in incompleteTasks) {
      if (task.dueAt != null) {
        await scheduleReminder(
          task.id,
          task.name,
          task.dueAt!,
          remindBefore: task.remindBefore,
        );
      }
    }
  }

  // Data sent by the Cloud Function (functions/index.js):
  // { action: 'schedule' | 'cancel', taskId, name, date, time, dueAt? (ms),
  //   remindBefore? (minutes) }
  static Future<void> handleTaskMessage(Map<String, dynamic> data) async {
    final taskId = data['taskId'];
    if (taskId is! String) return;
    if (data['action'] == 'schedule' && await _serverSendsReminders()) return;
    if (data['action'] == 'cancel') {
      await cancelReminder(taskId);
      return;
    }
    if (data['action'] != 'schedule') return;
    final ms = int.tryParse('${data['dueAt'] ?? ''}');
    final dueAt = ms != null
        ? DateTime.fromMillisecondsSinceEpoch(ms)
        : parseDue('${data['date']}', '${data['time']}');
    if (dueAt != null) {
      await scheduleReminder(
        taskId,
        '${data['name']}',
        dueAt,
        remindBefore: int.tryParse('${data['remindBefore']}') ?? 0,
      );
    }
  }

  // ---- Push (FCM) ----

  static Future<void> registerPush() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    try {
      // On iOS a token is only available once APNs is set up for the project
      final token = await messaging.getToken();
      if (token != null) await _saveToken(uid, token);
    } catch (e) {
      debugPrint('Push not available: $e');
    }
  }

  static void listenForPush() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) _saveToken(uid, token);
    });

    // FCM doesn't display notifications while the app is open, so show it
    // ourselves and apply any reminder change it carries.
    FirebaseMessaging.onMessage.listen((message) async {
      await handleTaskMessage(message.data);
      final notification = message.notification;
      if (notification != null) {
        await _plugin.show(
          id: message.hashCode & 0x7fffffff,
          title: notification.title,
          body: notification.body,
          notificationDetails: _details,
        );
      }
    });
  }

  // iOS tokens are also listed separately so the server reminder job only
  // pushes to iPhones (Android schedules its own).
  static Future<void> _saveToken(String uid, String token) =>
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
        if (_isIOS) 'iosTokens': FieldValue.arrayUnion([token]),
      });

  // Called before sign out so the next person to use this phone doesn't get
  // the previous user's pushes or reminders.
  static Future<void> unregister() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (uid != null && token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'fcmTokens': FieldValue.arrayRemove([token]),
          'iosTokens': FieldValue.arrayRemove([token]),
        });
      }
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint('Push unregister failed: $e');
    }
    await cancelAll();
  }
}
