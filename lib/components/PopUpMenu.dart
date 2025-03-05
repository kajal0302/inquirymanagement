import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';

class Popupmenu extends StatefulWidget {
  final String id;
  final Function(SampleItem, String) onSelectedCallback;
  final bool remove, call, installment, syllabus;

  const Popupmenu(
      {super.key,
      required this.onSelectedCallback,
      required this.id,
      required this.remove,
      required this.call,
      required this.installment,
      required this.syllabus});

  @override
  State<Popupmenu> createState() => _PopupmenuState();
}

enum SampleItem { remove, call, installment, syllabus }

class _PopupmenuState extends State<Popupmenu> {
  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      color: white,
      initialValue: selectedItem,
      onSelected: (SampleItem item) {
        setState(() {
          selectedItem = item;
        });
        widget.onSelectedCallback(item, widget.id);
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<SampleItem>> items = [];

        if (widget.remove) {
          items.add(
            const PopupMenuItem<SampleItem>(
              value: SampleItem.remove,
              child: Text('Remove'),
            ),
          );
        }

        if (widget.call) {
          items.add(
            const PopupMenuItem<SampleItem>(
              value: SampleItem.call,
              child: Text('Call'),
            ),
          );
        }

        if (widget.installment) {
          items.add(
            const PopupMenuItem<SampleItem>(
              value: SampleItem.installment,
              child: Text('Installment'),
            ),
          );
        }

        if (widget.syllabus) {
          items.add(
            const PopupMenuItem<SampleItem>(
              value: SampleItem.syllabus,
              child: Text('Syllabus'),
            ),
          );
        }

        return items;
      },
    );
  }
}
