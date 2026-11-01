import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:remindmi/app/routes/app_pages.dart';
import 'package:remindmi/app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(
    //options: const FirebaseOptions(
    //apiKey: "AIzaSyAjHrEgelTJnSA95ucyZME2N3tM43S0JVw",
    //appId: "1:526204885343:android:27fe86d00f0ff83bf8beea",
    //messagingSenderId: "526204885343",
    //projectId: "remindmi-ab6c6",
    // ),
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.init();
  NotificationService.listenForPush();
  if (FirebaseAuth.instance.currentUser != null) {
    // Refresh the push token for an already signed-in user
    NotificationService.registerPush();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      title: "RemindMi",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
