import 'package:inquirymanagement/common/color.dart';
import 'package:flutter/material.dart';

Widget buildFilterModal(
    BuildContext context,
    int selectedValue,
    Function(int) onValueChanged,
    Function() changeTemplate) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setStateModal) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Additional',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(thickness: 2.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Students From:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: lightBlueColor),
              ),
            ),
            RadioListTile(
              title: const Text('Inquiries'),
              value: 2,
              groupValue: selectedValue,
              onChanged: (value) {
                setStateModal(() {
                  selectedValue = value!;
                });
                // Update _selectedValue in SmsScreen
                onValueChanged(value!);
              },
            ),
            RadioListTile(
              title: const Text('Batches'),
              value: 1,
              groupValue: selectedValue,
              onChanged: (value) {
                setStateModal(() {
                  selectedValue = value!;
                });
                // Update _selectedValue in SmsScreen
                onValueChanged(value!);
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Change Template:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: lightBlueColor),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: changeTemplate,
              child: const Text(
                "Choose Template",
                style: TextStyle(color: lightBlueColor),
              ),
            ),
          ],
        ),
      );
    },
  );
}
