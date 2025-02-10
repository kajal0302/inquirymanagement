import 'package:flutter/material.dart';

class btnWidget extends StatelessWidget {
  final Color btnBgColor;
  final BorderRadius btnBrdRadius;
  final String btnLabel;
  final Color btnLabelColor;
  final double btnLabelFontSize;
  final FontWeight btnLabelFontWeight;
  final VoidCallback onClick;
  const btnWidget({
    super.key,
    required this.onClick,
    required this.btnBgColor,
    required this.btnBrdRadius,
    required this.btnLabel,
    required this.btnLabelColor,
    required this.btnLabelFontWeight,
    required this.btnLabelFontSize
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton
            .styleFrom(
            backgroundColor: btnBgColor,
            shape: RoundedRectangleBorder(
                borderRadius: btnBrdRadius
            )
        ),
        onPressed: onClick,
        child: Text(btnLabel,textAlign: TextAlign.center,style: TextStyle(color: btnLabelColor,fontSize: btnLabelFontSize,fontWeight: btnLabelFontWeight),)
    );
  }
}