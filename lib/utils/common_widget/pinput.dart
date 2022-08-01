import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:milk_bazzar/models/login_models/loginModels.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:get/get.dart';

import '../../modules/Customer/otp/controller/otp_controller.dart';

class RoundedWithCustomCursor extends StatefulWidget {
  @override
  _RoundedWithCustomCursorState createState() =>
      _RoundedWithCustomCursorState();

  @override
  String toStringShort() => 'Rounded With Cursor';
}

class _RoundedWithCustomCursorState extends State<RoundedWithCustomCursor> {

  final OtpController otpVerificationController = Get.put(OtpController());



  BoxDecoration get pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.blue),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  @override
  void dispose() {
    LoginModels.pinPutController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = AppColors.darkBlue;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = AppColors.darkBlue;

    return  Container(
        child: PinPut(
          fieldsCount: 6,
          onChanged: (String pin){
            if(pin.length == 6){
              otpVerificationController.isPinPut.value = true;
            }
            else
            {
              otpVerificationController.isPinPut.value = false;
            }},

          focusNode: LoginModels.pinPutFocusNode,
          controller: LoginModels.pinPutController,
          submittedFieldDecoration: pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(10),
          ),
          selectedFieldDecoration: pinPutDecoration,
          followingFieldDecoration: pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.blue.withOpacity(.5),
            ),
          ),
          textStyle:  TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
            fontFamily: "Graphik",
            fontWeight: FontWeight.w500,
          ),
        ),
    );
  }
}
