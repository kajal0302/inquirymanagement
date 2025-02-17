import 'package:flutter/material.dart';

import '../common/color.dart';
import '../common/size.dart';

class DropDown extends StatefulWidget {
  final List<String>? items;
  final List<Map<String, String>>? mapItems;
  final String? preSelectedValue;
  final bool status;
  final String lbl;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final heightofSize;

  const DropDown({
    super.key,
    this.items,
    this.mapItems,
    this.preSelectedValue,
    required this.status,
    required this.lbl,
    this.controller,
    this.onChanged,
    this.heightofSize = px20
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    _setDropdownValue();

    if (widget.controller != null && widget.controller!.text.isEmpty) {
      widget.controller!.text = dropdownValue;
    }
  }

  void _setDropdownValue() {
    if (widget.mapItems != null && widget.mapItems!.isNotEmpty) {
      dropdownValue = (widget.preSelectedValue ?? widget.mapItems!.first['id']!);
    } else if (widget.items != null && widget.items!.isNotEmpty) {
      dropdownValue = (widget.preSelectedValue ?? widget.items!.first);
    } else {
      dropdownValue = "";
    }
  }

  @override
  void didUpdateWidget(covariant DropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mapItems != widget.mapItems || oldWidget.items != widget.items || oldWidget.preSelectedValue != widget.preSelectedValue) {
      _setDropdownValue();

      // Update the controller's text only if necessary
      if (widget.controller != null && widget.controller!.text != dropdownValue) {
        widget.controller!.text = dropdownValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50), // Added border radius here
            border: Border.all(color: grey_300 ),
          ),
          child: DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                style: TextStyle(color: black),
                value: widget.mapItems != null && widget.mapItems!.isNotEmpty || widget.items != null && widget.items!.isNotEmpty
                    ? dropdownValue
                    : null,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: widget.status && (widget.mapItems != null && widget.mapItems!.isNotEmpty || widget.items != null && widget.items!.isNotEmpty)
                    ? (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;

                    if (widget.controller != null) {
                      widget.controller!.text = dropdownValue;
                    }

                    if (widget.onChanged != null) {
                      widget.onChanged!(dropdownValue);
                    }
                  });
                }
                    : null,
                items: widget.mapItems != null
                    ? widget.mapItems?.map<DropdownMenuItem<String>>((Map<String, String> item) {
                  return DropdownMenuItem<String>(
                    value: item['id'],
                    child: Text(item['value']!),
                  );
                }).toList()
                    : widget.items?.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true,
                itemHeight: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }
}