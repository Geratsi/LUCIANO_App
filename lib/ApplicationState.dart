
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    log('init');
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    print('__FCM_token__');
    print(token);
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      print('refresh token $fcmToken');
    }).onError((error) {print(error);});

    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print(settings);
  }

  void signOut() {
  }
}