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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          widget,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  onCancel();
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                    color: red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  filterInquiriesByDate();
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}