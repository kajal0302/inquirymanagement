import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:shimmer/shimmer.dart';

class StudentListSkeleton extends StatelessWidget {
  const StudentListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 2.0),
                  child: Card(
                    color: grey_200,
                    elevation: 3,
                    child: ListTile(
                      leading: ShimmerWidget.circular(height: 40, width: 40),

                      /// Image
                      title: ShimmerWidget.rectangular(height: 16, width: 150),

                      /// Name
                      subtitle:
                          ShimmerWidget.rectangular(height: 14, width: 100),

                      /// Course
                      trailing: ShimmerWidget.circular(height: 24, width: 24),

                      /// Checkbox
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///  Shimmer Widget
class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircular;

  const ShimmerWidget.rectangular({
    Key? key,
    required this.height,
    required this.width,
  })  : isCircular = false,
        super(key: key);

  const ShimmerWidget.circular({
    Key? key,
    required this.height,
    required this.width,
  })  : isCircular = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: grey_300,
      highlightColor: grey_100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: white,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(5),
        ),
      ),
    );
  }
}
