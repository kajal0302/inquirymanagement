import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

Future<File?> pickDocumentFromStorage() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf','doc'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error picking image from storage: $e");
    }
  }
  return null;
}
