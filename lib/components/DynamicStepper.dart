import 'package:flutter/material.dart';

import '../common/color.dart';


class DynamicStepper extends StatefulWidget {
  final List<Map> dynamicSteps;

  const DynamicStepper({
    super.key,
    required this.dynamicSteps
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
        steps: widget.dynamicSteps.asMap().entries.map((entry) {
          int stepIndex = entry.key;
          Map stepData = entry.value;

          return Step(
            title: Text(stepData["title"] ?? 'Step ${stepIndex + 1}' ,style: const TextStyle(
              color: primaryColor, // 🔹 Change Heading Color
              fontWeight: FontWeight.bold,
            ),),
            content: Container(
              alignment: Alignment.centerLeft,
              child: stepData["content"],
            ),
            state: completedSteps[stepIndex] ? StepState.complete : StepState.indexed,
            isActive: currentIndex == stepIndex,
          );
        }).toList(),
      ),
    );
  }
}