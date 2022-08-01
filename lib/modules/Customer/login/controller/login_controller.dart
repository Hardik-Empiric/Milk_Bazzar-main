import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../models/login_models/loginModels.dart';

class LoginController extends GetxController {
  RxBool isChecked = false.obs;

  sendOtp({required String phone}) async {

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        LoginModels.verificationId = verificationId;
        LoginModels.resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
