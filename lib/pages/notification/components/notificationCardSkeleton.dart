import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';

class NotificationCardSkeleton extends StatelessWidget {
  const NotificationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(px18),
      ),
      color: grey_400,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading Icon Placeholder
            Shimmer.fromColors(
              baseColor: grey_300,
              highlightColor: grey_100,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Title & Subtitle Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Shimmer.fromColors(
                    baseColor: grey_300,
                    highlightColor: grey_100,
                    child: Container(
                      height: 18,
                      width: 200,
                      color: white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: grey_300,
                    highlightColor: grey_100,
                    child: Container(
                      height: 14,
                      width: 150, // Limit width for better layout
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
            // Trailing Icon Placeholder
            Shimmer.fromColors(
              baseColor: grey_300,
              highlightColor: grey_100,
              child: Container(
                width: 5,
                height: 24,
                color: white,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
