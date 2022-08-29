import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/login_models/loginModels.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../../utils/common_widget/pinput.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/otp_controller.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key}) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final GlobalKey<FormState> _globalFromKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  final OtpController otpVerificationController = Get.put(OtpController());



  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpVerificationController.counter.value > 0) {
        otpVerificationController.counter.value--;
      } else {
        otpVerificationController.isResend.value = true;
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).backgroundColor,
                  boxShadow:  [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: const Offset(0, 0),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, bottom: 20, top: 0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: appLogo(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          child: GlobalText(
                            color: Theme.of(context).primaryColor,
                              text: LocaleString().otpVerificationText.tr,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        GlobalText(
                            text:
                            "${LocaleString().sentMsg.tr} +91 ${LoginModels.phone}",
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w500),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GlobalText(
                                  text: LocaleString().resendMsg.tr,
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400),
                            ),
                            Obx(
                                  () =>
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: GlobalText(
                                        text:
                                        "00:${otpVerificationController.counter
                                            .value.toString()}",
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Form(
                            key: _globalFromKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoundedWithCustomCursor(),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                              () =>
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary:
                                    (otpVerificationController.isPinPut.value)
                                        ? Theme.of(context).backgroundColor
                                        : AppColors.blue,
                                    primary:
                                    (otpVerificationController.isPinPut.value)
                                        ? AppColors.blue
                                        : AppColors.lightBlue,
                                    fixedSize: Size(SizeData.width * 0.7, 45),
                                  ),
                                  onPressed: () async {
                                    if (_globalFromKey.currentState!
                                        .validate()) {
                                      _globalFromKey.currentState!.save();

                                      LoginModels.otp = int.parse(
                                          LoginModels.pinPutController.text);

                                      String smsCode =
                                          LoginModels.pinPutController.text;

                                      // Create a PhoneAuthCredential with the code

                                      otpVerificationController.verifyOTP(
                                          vid: LoginModels.verificationId!,
                                          smsCode: smsCode);
                                    }
                                  },
                                  child: GlobalText(
                                    text: LocaleString().continueText.tr,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GlobalText(
                              text: LocaleString().didNotReceiveOtp.tr,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),

                            Obx(
                                  () =>
                              (otpVerificationController.isResend.value)
                                  ? GestureDetector(
                                onTap: () async {
                                  if (otpVerificationController.counter.value ==
                                      0) {
                                    otpVerificationController.counter.value = 60;
                                    otpVerificationController.isResend.value = false;

                                   await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: "+91${LoginModels.phone.toString()}",

                                      codeSent: (String verificationId,
                                          int? forceResendingToken) {},
                                      verificationFailed: (
                                          FirebaseAuthException error) {},
                                      codeAutoRetrievalTimeout: (String verificationId) {  },
                                      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },);
                                  }
                                },
                                child: GlobalText(
                                  text: LocaleString().resendOtp.tr,
                                  color: AppColors.darkBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              )
                                  : GlobalText(
                                text: LocaleString().resendOtp.tr,
                                color: AppColors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
