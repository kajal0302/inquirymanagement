import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image from gallery: $e");
      }
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image from camera: $e");
      }
    }
    return null;
  }

  Future<File?> pickImageFromStorage() async {
    try {
      final XFile? file = await _picker.pickMedia();
      if (file != null) {
        return File(file.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image from storage: $e");
      }
    }
    return null;
  }

  Future<File?> pickVideoFromGallary() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        return File(file.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image from storage: $e");
      }
    }
    return null;
  }
}