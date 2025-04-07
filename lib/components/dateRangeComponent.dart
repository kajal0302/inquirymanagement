import 'package:flutter/material.dart';
import '../common/color.dart';


class DateRangeDialog extends StatelessWidget {
  final Widget widget;
  final VoidCallback filterInquiriesByDate;
  final VoidCallback onCancel;

  const DateRangeDialog({
    Key? key,
    required this.widget,
    required this.filterInquiriesByDate,
    required this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: preIconFillColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Select Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          widget,
          Divider(height: 1), // Minimal height to remove extra space
          Row(
            children: [
              // CANCEL Button
              Expanded(
                child: TextButton(
                  onPressed: () {
                    onCancel();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: white,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(2),
                      ),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Vertical Divider between buttons
              Container(
                width: 1,
                height: 48,
                color: grey_300,
              ),

              // OK Button
              Expanded(
                child: TextButton(
                  onPressed: () {
                    filterInquiriesByDate();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: white,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}