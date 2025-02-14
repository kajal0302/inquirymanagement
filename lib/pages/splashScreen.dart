import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';

import '../main.dart';
import 'dashboard/screen/dashboard.dart';

class splashScreenPage extends StatefulWidget {
  const splashScreenPage({super.key});

  @override
  State<splashScreenPage> createState() => _splashScreenPageState();
}

class _splashScreenPageState extends State<splashScreenPage> {
  @override

  @override
  void initState() {
    super.initState();
    // Set the time Duration 2 seconds for SplashScreen after that navigate to Dashboard Screen
    Timer(Duration(seconds: 2),checkLoginStatus);
  }

  //Check Login Status
  Future<void> checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Optional delay for splash effect

    if (userBox.containsKey('id')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: 
          Image.asset(splashScreenImage,fit: BoxFit.cover,),
          )
        ],
      ),
    );
  }
}
