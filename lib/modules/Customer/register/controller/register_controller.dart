

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../../models/login_models/loginModels.dart';


class RegisterController extends GetxController{

  sendOtp({required String phone}) async {

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted:
          (PhoneAuthCredential credential) async {

      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent:
          (String verificationId, int? resendToken) async {

        LoginModels.verificationId = verificationId;
        LoginModels.resendToken = resendToken;

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }

}