import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


// Access to the camera or storage
Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.storage,
  ].request();
}


// Open a given URL in the device's default external web browser
Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}


// Open an image URL using the device's default application for viewing images

Future<void> launchImage(Uri imageUrl) async {
  if (await canLaunchUrl(imageUrl)) {
    await launchUrl(imageUrl);
  } else {
    throw 'Could not launch $imageUrl';
  }
}


//  Open a given URL within an in-app browser view rather than the device's default web browser
Future<void> launchInBrowserView(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
    throw Exception('Could not launch $url');
  }
}

// Open a PDF from a given URL within an in-app web view in a Flutter application.
void openPdf(String url) async {
  if (await canLaunchUrlString(url)) {
    Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}


//  Open a given URL inside an in-app web view in a Flutter application,
//  but with DOM Storage (Document Object Model storage) disabled

Future<void> launchInWebViewWithoutDomStorage(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
  )) {
    throw Exception('Could not launch $url');
  }
}


// To handle the opening of a URL on iOS devices. It first tries to launch the
// URL in a native app (if it supports universal links),
// and if that fails, it falls back to opening the URL in an in-app browser view

Future<void> launchUniversalLinkIOS(Uri url) async {
  final bool nativeAppLaunchSucceeded = await launchUrl(
    url,
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
    );
  }
}

Widget launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
  if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
  } else {
    return const Text('');
  }
}


// To check and request the necessary permission for making phone calls on a device
Future<bool> requestCallPermission() async {
  var status = await Permission.phone.status;

  // If denied, it requests the permission.
  if (status.isDenied) {
    status = await Permission.phone.request();
  }

  return status.isGranted;
}

// Opens the device's phone dialer with the specified phone number
Future<void> makePhoneCall(String phoneNumber) async {
  bool hasPermission  = await requestCallPermission();
  if (hasPermission ) {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }else{
    requestCallPermission();
  }
}

