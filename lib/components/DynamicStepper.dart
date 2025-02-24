import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/style.dart';

class DynamicStepper extends StatefulWidget {
  final List<Map> dynamicSteps;
  final VoidCallback voidCallback;

  const DynamicStepper({
    super.key,
    required this.dynamicSteps,
    required this.voidCallback
  });

  @override
  _DynamicStepperState createState() => _DynamicStepperState();
}

class _DynamicStepperState extends State<DynamicStepper> {
  int currentIndex = 0;
  List<bool> completedSteps = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: Colors.grey,
        ),
      ),
      child: Stepper(
        currentStep: currentIndex,
        onStepCancel: () {
          if (currentIndex > 0) {
            setState(() {
              currentIndex -= 1;
            });
          }
        },
        onStepContinue: () {
          setState(() {
            if (currentIndex < widget.dynamicSteps.length - 1) {
              completedSteps[currentIndex] = true;
              currentIndex += 1;
            } else {
              completedSteps[currentIndex] = true;
            }
          });
        },
        onStepTapped: (int step) {
          setState(() {
            currentIndex = step;
          });
        },

        steps: widget.dynamicSteps.asMap().entries.map((entry) {
          int stepIndex = entry.key;
          Map stepData = entry.value;
          return Step(
            title: Text(
              stepData["title"] ?? 'Step ${stepIndex + 1}',
              style: primary_heading_4_bold,
            ),
            content: Container(
              width: double.infinity,
              child: Card(
                elevation: 3,
                color: bv_secondaryLightColor3,
                child: Padding(padding: EdgeInsets.all(10),child: stepData["content"],),
              ),
            ),
            state: completedSteps[stepIndex] ? StepState.complete : StepState.indexed,
            isActive: currentIndex == stepIndex,
          );

        }).toList(),

        // Custom Button Styles
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          bool isFirstStep = currentIndex == 0;
          bool isLastStep = currentIndex == widget.dynamicSteps.length - 1;

          return Row(
            children: [
              // Submit button only on the last step
              if (isLastStep)
                ElevatedButton(
                  onPressed: widget.voidCallback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Submit"),
                )
              else
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Next"),
                ),

              const SizedBox(width: 10),

              // Back button should not be on the first step, but should be visible on last step
              if (!isFirstStep)
                TextButton(
                  onPressed: details.onStepCancel,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Back"),
                ),
            ],
          );
        },
      ),
    );
  }
}