import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inquirymanagement/pages/course/provider/CourseProvider.dart';
import 'package:inquirymanagement/pages/students/provider/branchProvider.dart';
import 'package:inquirymanagement/pages/students/provider/categoryProvider.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/pages/users/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/login/model/branch.dart';
import 'package:inquirymanagement/pages/splashScreen.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/notification_service.dart';
import 'firebase_options.dart';

late Box userBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(BranchAdapter());
  userBox = await Hive.openBox(loginPref);

  await NotificationService.initialize();
  NotificationService.handleForegroundNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => StudentBranchProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: const splashScreenPage(),
    );
  }
}
