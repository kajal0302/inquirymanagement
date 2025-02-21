import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inquirymanagement/common/color.dart';
import '../common/size.dart';

class FormInputBox extends StatelessWidget {
  final String title;
  final String? type;
  final TextEditingController textEditingController;
  final bool status;
  final int? maxLength;
  final int? maxLine;
  final bool? boolStatus;
  final Function(String)?onChanged;
  final String? Function(String?)? validator;
  final Widget? child;

  const FormInputBox({
    super.key,
    required this.title,
    this.type,
    required this.textEditingController,
    required this.status,
    this.maxLength = 50,
    this.onChanged,
    this.maxLine,
    this.validator,
    this.boolStatus = false,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: px10),
        TextFormField(
          readOnly: boolStatus ?? false,
          validator: validator,
          maxLines: maxLine,
          enabled: status,
          style: TextStyle(color: black,fontSize: px15),
          textInputAction: TextInputAction.go,
          controller: textEditingController,
          maxLength: maxLength,
          keyboardType: _getKeyboardType(),
          inputFormatters: _getInputFormatters(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            counterText: '',
            labelText: title,
            errorText: validator != null ? validator!(textEditingController.text) : null,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  TextInputType _getKeyboardType() {
    switch (type) {
      case "number":
        return TextInputType.number;
      case "email":
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    switch (type) {
      case "number":
        return [FilteringTextInputFormatter.digitsOnly];
      case "email":
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]'))];
      case "text":
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))]; // Allow spaces
      default:
        return [];
    }
  }

}


//
// class BatchSelectionDialog extends StatefulWidget {
//   final List<Batches> batches;
//   final Function(List<Batches>) onBatchesSelected;

//   const BatchSelectionDialog({Key? key,
//     required this.batches,
//     required this.onBatchesSelected,
//   }) : super(key: key);
//
//   @override
//   _BatchSelectionDialogState createState() => _BatchSelectionDialogState();
// }
//
// class _BatchSelectionDialogState extends State<BatchSelectionDialog> {
//   List<Batches> selectedBatches = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize selectedBatches with any pre-selected batches if needed
//     selectedBatches = widget.batches.where((batch) => batch.isChecked!).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select Batches'),
//       content: SingleChildScrollView(
//         child: Column(
//           children: widget.batches.map((batch) {
//             return CheckboxListTile(
//               title: Text(batch.name!),
//               value: batch.isChecked,
//               onChanged: (value) {
//                 setState(() {
//                   batch.isChecked = value!;
//                   if (value) {
//                     selectedBatches.add(batch);
//                   } else {
//                     selectedBatches.remove(batch);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             widget.onBatchesSelected(selectedBatches);
//             Navigator.of(context).pop();
//           },
//           child: const Text('OK'),
//         ),
//       ],
//     );}
// }
