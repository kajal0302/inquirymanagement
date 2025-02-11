import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:inquirymanagement/common/color.dart';
import '../../../common/size.dart';

class BranchCardSkeleton extends StatelessWidget {
  const BranchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(px10),
          side: BorderSide(color: grey_400, width: 1),
        ),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton for heading
            Shimmer.fromColors(
              baseColor: grey_300,
              highlightColor: grey_100,
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: colorGrey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(px10)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Skeleton for rows
            _buildSkeletonRow(),
            _buildSkeletonRow(),
            _buildSkeletonRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // Icon Placeholder
          Shimmer.fromColors(
            baseColor: grey_300,
            highlightColor: grey_100,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: grey_300,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Text Placeholder
          Shimmer.fromColors(
            baseColor: grey_300,
            highlightColor: grey_100,
            child: Container(
              width: 150,
              height: 16,
              color: grey_300,
            ),
          ),
        ],
      ),
    );
  }
}
