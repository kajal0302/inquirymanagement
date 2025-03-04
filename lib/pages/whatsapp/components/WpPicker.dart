import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/size.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/image_picker_service.dart';
import 'package:inquirymanagement/utils/file_picker_service.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';
import 'package:video_player/video_player.dart';

class WpPicker extends StatefulWidget {
  final String image;
  final bool status;
  final bool camera;
  final bool video;
  final bool document;
  final Function(File) onImagePicked;

  const WpPicker({
    super.key,
    required this.image,
    required this.status,
    required this.onImagePicked,
    this.camera = false,
    this.video = false,
    this.document = false,
  });

  @override
  State<WpPicker> createState() => _WpPickerState();
}

class _WpPickerState extends State<WpPicker> {
  File? _image;
  VideoPlayerController? _videoController;
  final ImagePickerService _imagePickerService = ImagePickerService();

  /// Initialize the VideoPlayerController with the selected video file
  Future<void> _initializeVideoPlayer(File videoFile) async {
    if (kDebugMode) {
      print("Initializing video player with file: ${videoFile.path}");
    }
    // Dispose the previous controller if it exists
    if (_videoController != null) {
      await _videoController!.dispose();
    }

    _videoController = VideoPlayerController.file(videoFile);
    try {
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      setState(() {}); // Update the UI after initialization
      _videoController!.play();
      if (kDebugMode) {
        print("Video initialized and playing.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing video player: $e");
      }
    }
  }

  /// Handle image picking from camera
  Future<void> pickImageFromCamera() async {
    final pickedImage = await _imagePickerService.pickImageFromCamera();
    if (pickedImage != null) {
      if (kDebugMode) {
        print("Image picked from camera: ${pickedImage.path}");
      }
      setState(() {
        _image = pickedImage;
        _videoController?.pause();
        _videoController = null; // Clear any existing video
      });
      widget.onImagePicked(pickedImage);
    }
  }

  /// Handle image picking from gallery
  Future<void> pickImageFromGallery() async {
    final pickedImage = await _imagePickerService.pickImageFromGallery();
    if (pickedImage != null) {
      if (kDebugMode) {
        print("Image picked from gallery: ${pickedImage.path}");
      }
      setState(() {
        _image = pickedImage;
        _videoController?.pause();
        _videoController = null; // Clear any existing video
      });
      widget.onImagePicked(pickedImage);
    }
  }

  /// Handle video picking from gallery
  Future<void> pickVideoFromGallery() async {
    final pickedVideo = await _imagePickerService.pickVideoFromGallary();
    if (pickedVideo != null) {
      if (kDebugMode) {
        print("Video picked from gallery: ${pickedVideo.path}");
      }
      await _initializeVideoPlayer(pickedVideo);
      widget.onImagePicked(pickedVideo);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  /// Display the dialog for selecting resources
  Future<File?> buildShowDialog(BuildContext context) {
    return showDialog<File>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Select Resource",
                style: TextStyle(fontSize: px18),
              ),
              const SizedBox(height: px20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (widget.camera)
                    _resourceOption(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () async {
                        final pickedFile =
                            await _imagePickerService.pickImageFromCamera();
                        requestPermissions();
                        Navigator.pop(context, pickedFile);
                      },
                    ),
                  if (widget.camera)
                    _resourceOption(
                      icon: FontAwesomeIcons.image,
                      label: "Gallery",
                      onTap: () async {
                        final galleryFile =
                            await _imagePickerService.pickImageFromGallery();
                        Navigator.pop(context, galleryFile);
                      },
                    ),
                  if (widget.document)
                    _resourceOption(
                      icon: FontAwesomeIcons.solidFile,
                      label: "Files",
                      onTap: () async {
                        final storageFile = await pickDocumentFromStorage();
                        Navigator.pop(context, storageFile);
                      },
                    ),
                  if (widget.video)
                    _resourceOption(
                      icon: FontAwesomeIcons.video,
                      label: "Video",
                      onTap: () async {
                        final videoFile =
                            await _imagePickerService.pickVideoFromGallary();
                        Navigator.pop(context, videoFile);
                      },
                    ),
                ],
              ),
              const SizedBox(height: px20),
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

  /// Helper method to create a resource option widget
  Widget _resourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: px35),
          const SizedBox(height: px10),
          Text(label, style: const TextStyle(fontSize: px16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String document = "Please Select Document";
    return GestureDetector(
      onTap: () async {
        if (widget.status) {
          File? pickedFile = await buildShowDialog(context);
          if (pickedFile != null) {
            if (widget.video && _image == null) {
              // If video is enabled and no image is set
              await _initializeVideoPlayer(pickedFile);
            } else if (widget.document && _image == null) {
              setState(() {
                document = "document selected";
              });
            } else {
              // Else, treat as image
              setState(() {
                _image = pickedFile;
                _videoController?.pause();
                _videoController = null;
              });
            }
            widget.onImagePicked(pickedFile);
          }
        }
      },
      child: Stack(
        children: [
          // Display Video Player if video is selected and initialized
          if (_videoController != null && _videoController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )

          // Display Image if image is selected
          else if (_image != null)
            Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              image: FileImage(_image!),
              fit: BoxFit.cover,
            )

          // Display default image if no image or video is selected
          else if (widget.document &&
              _image != null &&
              _videoController == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.solidFilePdf,
                  color: Colors.redAccent,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  document,
                  style: const TextStyle(color: colorBlackAlpha, fontSize: px16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            )
          else
              Image.network(
                widget.image.isEmpty ? userImageUri : widget.image,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
          // Show loading indicator while video is initializing
          if (_videoController != null &&
              !_videoController!.value.isInitialized)
            const Center(child: CircularProgressIndicator()),

          // Play/Pause button overlay for video
          if (_videoController != null && _videoController!.value.isInitialized)
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                  size: px35,
                ),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
