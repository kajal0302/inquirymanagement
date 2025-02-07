import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/inputTextField.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';

import '../../../common/size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Center(child: Image.asset(loginImage,height: MediaQuery.of(context).size.height*0.4,width:  MediaQuery.of(context).size.width*0.6,)),
            SizedBox(
                height: 220,
                child: Card(
                  elevation: 4,
                  color: bv_secondaryLightColor3 ,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        InputTxt(
                            prefixIcon: Icon(
                              Icons.person,
                              color: colorAmber_900 ,
                              size: px28,),
                            label: "Username", controller: username )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
      
    );
  }
}
