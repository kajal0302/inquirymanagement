import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:inquirymanagement/common/color.dart';
import '../../../common/size.dart';

class ContactUsSkeleton extends StatelessWidget {
  const ContactUsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Email Section Skeleton
          _buildSkeletonRow(Icons.mail),
          SizedBox(height: 20),

          /// Contact Section Skeleton
          _buildSkeletonRow(Icons.phone),
          SizedBox(height: 20),

          /// Branch List Section Skeleton
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: px30, color: grey_400),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (index) => _buildBranchSkeleton()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Widget for Skeleton Row for Email & Contact
  Widget _buildSkeletonRow(IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: px30, color: grey_400),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerContainer(width: 200, height: 16),
              SizedBox(height: 10),
              _buildShimmerContainer(width: 150, height: 16),
              SizedBox(height: 20),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }

  /// Branch Skeleton Item
  Widget _buildBranchSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerContainer(width: 180, height: 16), // Branch Name
        SizedBox(height: 5),
        _buildShimmerContainer(width: double.infinity, height: 16), // Address
        SizedBox(height: 5),
        _buildShimmerContainer(width: 200, height: 16), // Contact
        SizedBox(height: 20),
        Divider(),
      ],
    );
  }

  ///  Shimmer Container
  Widget _buildShimmerContainer(
      {required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: grey_300, /// primary color
      highlightColor: grey_100, /// moving highlight color
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: grey_300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
