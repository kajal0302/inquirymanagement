import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/splashScreen.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/notification_service.dart';
import 'firebase_options.dart';


// Define the Hive box globally
late Box userBox;

void main() async {

  await Hive.initFlutter();
  userBox = await Hive.openBox(loginPref);  // Open a Hive box to store login data

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
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: splashScreenPage()
    );
  }
}

