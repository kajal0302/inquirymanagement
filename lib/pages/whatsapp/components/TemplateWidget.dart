import 'dart:io';
import 'package:inquirymanagement/common/text.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/whatsapp/components/WpPicker.dart';


class TemplateWidget extends StatelessWidget {
  final String templateString;
  final int camera;
  final int video;
  final int document;
  final List<String> bodyData;
  final Function(File?) onFilePicked;

  const TemplateWidget({
    super.key,
    required this.camera,
    required this.video,
    required this.document,
    required this.templateString,
    required this.bodyData,
    required this.onFilePicked,
  });

  @override
  Widget build(BuildContext context) {
    while (bodyData.length < templateString.split('#str').length - 1) {
      bodyData.add('');
    }

    List<Widget> content = _buildContentFromTemplate(templateString, bodyData);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...content
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContentFromTemplate(
      String templateString, List<String> bodyData) {
    List<String> parts = templateString.split('#str');
    List<Widget> widgets = [];

    if (camera == 1) {
      widgets.add(
        WpPicker(
          image: cameraImageUri,
          camera: true,
          status: true,
          onImagePicked: (file) {
            onFilePicked(file);
          },
        ),
      );
    }

    if (document == 1) {
      widgets.add(
        WpPicker(
          image: cameraImageUri,
          document: true,
          status: true,
          onImagePicked: (file) {
            onFilePicked(file);
          },
        ),
      );
    }

    if (video == 1) {
      widgets.add(
        WpPicker(
          image: cameraImageUri,
          video: true,
          status: true,
          onImagePicked: (file) {
            onFilePicked(file);
          },
        ),
      );
    }

    for (int i = 0; i < parts.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            parts[i],
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      );

      if (i != parts.length - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TextField(
              maxLength: 30,
              onChanged: (str) {
                bodyData[i] = str;
              },
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
