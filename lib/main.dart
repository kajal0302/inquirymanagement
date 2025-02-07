import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/splashScreen.dart';
import 'package:inquirymanagement/utils/notification_service.dart';

import 'firebase_options.dart';

void main() async {
  // Ensure that Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();
  NotificationService.handleForegroundNotifications();

  // Run your app
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splashScreenPage()
    );
  }
}

