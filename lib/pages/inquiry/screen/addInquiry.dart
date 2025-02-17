import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/dateField.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import '../../../components/appBar.dart';
import '../../../components/branchInputField.dart';
import '../../../components/dropDown.dart';
import '../../../utils/lists.dart';

class AddInquiryPage extends StatefulWidget {
  @override
  _AddInquiryPageState createState() => _AddInquiryPageState();
}

class _AddInquiryPageState extends State<AddInquiryPage> {
  int _currentStep = 0;

  //List of form steps
  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Personal Details',
      'content': PersonalDetailsForm(),
    },
    {
      'title': 'Inquiry Details',
      'content': InquiryDetailsForm(),
    },
  ];

  void _removeStep(int index) {
    if (_steps.length > 2) {
      setState(() {
        _steps.removeAt(index);
        if (_currentStep >= _steps.length) {
          _currentStep = _steps.length - 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgetAppbarForAboutPage(context, "Inquiry Form", DashboardPage()),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
          ),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          steps: _steps.asMap().entries.map((entry) {
            int index = entry.key;
            var step = entry.value;
            return Step(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step['title'],
                    style: const TextStyle(
                      color: primaryColor, // 🔹 Change Heading Color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (index >= 2) // Allow removal only for additional steps
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeStep(index),
                    ),
                ],
              ),
              content: step['content'],
              isActive: _currentStep >= index,
            );
          }).toList(),
          onStepContinue: () {
            if (_currentStep < _steps.length - 1) {
              setState(() => _currentStep++);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          onStepTapped: (step) {
            setState(() => _currentStep = step);
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor
                  ),
                  child: const Text('Next', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text(
                    'Back',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Forms for Personal Details
class PersonalDetailsForm extends StatelessWidget {

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController reference = TextEditingController();
  TextEditingController feedback = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 380,
        width: double.infinity,
        child: Card(
          color: bv_secondaryLightColor3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                BranchInputTxt(
                  label: "First Name",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: firstName,
                ),
                BranchInputTxt(
                  label: "Last Name",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: lastName,
                ),
                BranchInputTxt(
                  label: "Mobile no",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: mobileNo,
                ),
                DropDown(
                  key: Key('dropDown1'),
                  preSelectedValue: reference.text.isNotEmpty
                      ? (reference.text ?? '')
                      : (referenceBy.isNotEmpty
                      ? referenceBy.first
                      : ''),
                  controller: reference,
                  items: referenceBy,
                  status: true,
                  lbl: "Referenced By",
                ),
                BranchInputTxt(
                  label: "Feedback History",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: feedback,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Forms for Inquiry Details
class InquiryDetailsForm extends StatelessWidget {
  TextEditingController selectCourse = TextEditingController();
  TextEditingController selectBranch = TextEditingController();
  TextEditingController inquiryDate = TextEditingController();
  TextEditingController upcomingDate = TextEditingController();
  TextEditingController selectSmsType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 380,
        width: double.infinity,
        child: Card(
          color: bv_secondaryLightColor3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                BranchInputTxt(
                  label: "Select Course",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: selectCourse,
                ),
                BranchInputTxt(
                  label: "Select Branch",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: selectBranch,
                ),
                DateField(
                    firstDate: DateTime(1980, 1, 1),
                    lastDate: DateTime.now(),
                    label: "Inquiry Date",
                    controller: inquiryDate),
                DateField(firstDate: DateTime(1980, 1, 1), lastDate: DateTime.now(), label: "Upcoming Date", controller: upcomingDate),
                BranchInputTxt(
                  label: "Select Sms Type",
                  textColor:  black,
                  floatingLabelColor: preIconFillColor,
                  controller: selectSmsType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Forms for Additional Details
class AdditionalDetailsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(decoration: const InputDecoration(labelText: 'Custom Field')),
      ],
    );
  }
}
