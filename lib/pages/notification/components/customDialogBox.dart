import 'package:flutter/material.dart';

import '../../../common/color.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final double? width;
  const CustomDialog({required this.title, required this.child, this.width,this.height,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: height ?? MediaQuery.of(context).size.height * 0.8,
        width:  width ?? MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Background Color
            Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: preIconFillColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: child), // Custom Content Area
          ],
        ),
      ),
    );
  }
}
