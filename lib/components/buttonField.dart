import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';

import '../common/size.dart';

class button extends StatelessWidget {
  final double btnHeight;
  final double btnWidth;
  final VoidCallback onClick;
  final String btnLbl;
  final Color btnClr;
  final FontWeight btnFontWeigth;

  const button({
    super.key,
    required this.btnHeight,
    required this.btnWidth,
    required this.onClick,
    required this.btnLbl,
    required this.btnClr,
    required this.btnFontWeigth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight,
      width: btnWidth,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnClr,
        ),
        child: Text(
          btnLbl,
          style: TextStyle(fontSize: px18, color: white,
              fontWeight: btnFontWeigth),
        ),
      ),
    );
  }
}
