import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import '../common/size.dart';

class CustomCheckBoxTextField extends StatefulWidget {
  final String title;
  final bool status;
  final String titleText;
  final double fontSize;
  final TextEditingController controller;
  final List<dynamic> items;
  final bool includeAllCheckbox;
  final List<String> selectedItems;
  final String? Function(String?)? validator;
  final Function(List<String>)? onChanged;

  const CustomCheckBoxTextField({
    super.key,
    required this.title,
    this.fontSize = 18.0,
    required this.controller,
    required this.items,
    this.includeAllCheckbox = true,
    required this.titleText,
    required this.status,
    required this.selectedItems,
    this.validator,
    this.onChanged
  });

  @override
  _CustomCheckBoxTextFieldState createState() => _CustomCheckBoxTextFieldState();
}

class _CustomCheckBoxTextFieldState extends State<CustomCheckBoxTextField> {
  late List<CheckBoxWidget> checkBoxList;
  late CheckBoxWidget allChecked;

  @override
  void initState() {
    super.initState();
    checkBoxList = widget.items.map((item) {
      bool isSelected = widget.selectedItems.contains(item);
      return CheckBoxWidget(title: item, value: isSelected);
    }).toList();
    allChecked = CheckBoxWidget(title: 'All');
  }

  @override
  void didUpdateWidget(CustomCheckBoxTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        checkBoxList = widget.items.map((item) => CheckBoxWidget(title: item)).toList();
      });
    }
  }



  void toggleAll(CheckBoxWidget allItem) {
    final newValue = !allItem.value;
    setState(() {
      allItem.value = newValue;
      checkBoxList.forEach((element) {
        element.value = newValue;
        if (newValue) {
          if (!widget.selectedItems.contains(element.title)) {
            widget.selectedItems.add(element.title);
          }
        } else {
          widget.selectedItems.remove(element.title);
        }
      });
    });
    widget.onChanged?.call(List.from(widget.selectedItems));
  }



  void toggleItem(CheckBoxWidget item) {
    final newValue = !item.value;
    setState(() {
      item.value = newValue;

      if (newValue) {
        if (!widget.selectedItems.contains(item.title)) {
          widget.selectedItems.add(item.title);
        }
      } else {
        widget.selectedItems.remove(item.title);
      }
      allChecked.value = checkBoxList.every((element) => element.value);
    });

    widget.onChanged?.call(List.from(widget.selectedItems));
  }



  void showCheckBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                color: Colors.white,
                width: 400,
                height: 450,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      color: primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.titleText,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: px20,
                                color: white,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          if (widget.includeAllCheckbox)
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                toggleAll(allChecked);
                                setDialogState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      allChecked.title,
                                      style: TextStyle(
                                        fontSize: px14,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  Theme(
                                    data: ThemeData(
                                      checkboxTheme: CheckboxThemeData(
                                        side: BorderSide(color: Colors.white, width: 2.0),
                                        fillColor: WidgetStateProperty.resolveWith<Color?>(
                                              (Set<WidgetState> states) {
                                            if (states.contains(WidgetState.selected)) {
                                              return white;
                                            }
                                            return transparent;
                                          },
                                        ),
                                        checkColor: WidgetStateProperty.all(primaryColor),
                                      ),
                                    ),
                                    child: Checkbox(
                                      value: allChecked.value,
                                      onChanged: (value) {
                                        toggleAll(allChecked);
                                        setDialogState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: checkBoxList.map((item) => ListTile(
                            onTap: () {
                              toggleItem(item);
                              setDialogState(() {});
                            },
                            leading: Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  side: BorderSide(color: Colors.black, width: 2.0),
                                  fillColor: WidgetStateProperty.resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return colorGreen_900;
                                      }
                                      return transparent;
                                    },
                                  ),
                                  checkColor: WidgetStateProperty.all(white),
                                ),
                              ),
                              child: Checkbox(
                                value: item.value,
                                onChanged: (value) {
                                  toggleItem(item);
                                  setDialogState(() {});
                                },
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(fontSize: px18, color: black),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel", style: TextStyle(color: primaryColor, fontSize: px20)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.white),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                minimumSize: WidgetStateProperty.all(
                                  Size(double.infinity, 50),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                String selectedOptions = widget.selectedItems.join(', ');
                                widget.controller.text = selectedOptions;
                                Navigator.of(context).pop();
                              },
                              child: Text("Save", style: TextStyle(color: Colors.white, fontSize: px20)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(primaryColor),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                minimumSize: WidgetStateProperty.all(
                                  Size(double.infinity, 50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      if (widget.status) {
        showCheckBox(context);
      }
      },
      child: AbsorbPointer(
        absorbing: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: px15),
            TextFormField(
              validator:widget.validator,
              readOnly: true,
              enabled: widget.status,
              controller: widget.controller,
              style: TextStyle(color: black),
              textInputAction: TextInputAction.go,
              maxLength: 20,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(50),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  counter: null,
                  counterText: "",
                  labelText: widget.title,
                  labelStyle: TextStyle(
                    color: grey_500,
                    fontSize: px15,
                  ),
                  floatingLabelStyle: TextStyle(
                      color: colorBlackAlpha,
                      fontSize: px17,
                      fontWeight: FontWeight.normal),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxWidget {
  String title;
  bool value;

  CheckBoxWidget({
    required this.title,
    this.value = false,
  });
}
