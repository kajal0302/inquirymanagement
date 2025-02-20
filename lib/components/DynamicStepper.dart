import 'package:flutter/material.dart';


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
    return Stepper(
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
          title: Text(stepData["title"] ?? 'Step ${stepIndex + 1}'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: stepData["content"],
          ),
          state: completedSteps[stepIndex] ? StepState.complete : StepState.indexed,
          isActive: currentIndex == stepIndex,
        );
      }).toList(),
    );
  }
}