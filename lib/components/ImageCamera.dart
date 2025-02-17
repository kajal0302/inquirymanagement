import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/image_picker_service.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';

class ImageCamera extends StatefulWidget {
  final String image;
  final bool status;
  final Function(File) onImagePicked;

  const ImageCamera({
    super.key,
    required this.image,
    required this.status,
    required this.onImagePicked,
  });

  @override
  State<ImageCamera> createState() => _ImageCameraState();
}

class _ImageCameraState extends State<ImageCamera> {
  File? _image;
  final ImagePickerService _imagePickerService = ImagePickerService();

  Future<void> pickImageFromCamera() async {
    final pickedImage = await _imagePickerService.pickImageFromCamera();
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
        widget.onImagePicked(_image!);
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedImage = await _imagePickerService.pickImageFromGallery();
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
        widget.onImagePicked(_image!);
      });
    }
  }

  Future<void> pickImageFromFiles() async {
    final pickedImage = await _imagePickerService.pickImageFromStorage();
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
        widget.onImagePicked(_image!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.status) {
          File? pickedFile = await buildShowDialog(context);
          if (pickedFile != null) {
            setState(() {
              _image = pickedFile;
              widget.onImagePicked(_image!);
            });
          }
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: colorBlackAlpha,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : NetworkImage(
                          widget.image.isEmpty ? userImageUri : widget.image)
                      as ImageProvider,
              backgroundColor: Colors.white,
              radius: 25,
            ),
          ),
          Visibility(
            visible: widget.status,
            child: Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> buildShowDialog(BuildContext context) {
    return showDialog<File>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Select Resources",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final pickedFile =
                          await _imagePickerService.pickImageFromCamera();
                      requestPermissions();
                      Navigator.pop(context, pickedFile);
                    },
                    child: const Column(
                      children: [Icon(Icons.camera_alt), Text("Camera")],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      final gallaryFile =
                          await _imagePickerService.pickImageFromGallery();
                      Navigator.pop(context, gallaryFile);
                    },
                    child: const Column(
                      children: [Icon(FontAwesomeIcons.image), Text("Gallery")],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      final storageFile =
                          await _imagePickerService.pickImageFromStorage();
                      Navigator.pop(context, storageFile);
                    },
                    child: const Column(
                      children: [
                        Icon(FontAwesomeIcons.solidFile),
                        Text("Files")
                      ],
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
