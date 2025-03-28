import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/Update/model/UpdateModel.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateNowScreen extends StatelessWidget {
  final String updateMessage = "A new version of the app is available!";
  final String featureDetails = "Get the latest features, improvements, and bug fixes by updating now.";
  final UpdateModel? data;
  const UpdateNowScreen({super.key,this.data});

  Future<void> _launchAppStore(BuildContext context) async {
    const url = appUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open the app store. Please try again later.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  loginImage,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                // Title
                const Text(
                  "Update Available!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  updateMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  data!.message.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Update Now Button
                ElevatedButton(
                  onPressed: () => _launchAppStore(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Update Now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Skip Button
                TextButton(
                  onPressed: () {
                    if(data?.isRequired == 0){
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    data?.isRequired == 0 ? "Skip for Now" : "You can not skip this update",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
