import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/models/login_models/loginModels.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/app_colors.dart';
import '../../language/controller/LacaleString.dart';

class OtpController extends GetxController {
  RxBool isPinPut = false.obs;

  RxInt counter = 60.obs;

  RxBool isResend = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  verifyOTP({required String vid, required String smsCode}) async {

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vid, smsCode: smsCode);

    await auth.signInWithCredential(credential);

    Get.snackbar(LocaleString().correctOTP.tr, LocaleString().loginSuccess.tr,
        backgroundColor: AppColors.darkBlue, colorText: AppColors.white);

    Get.offAllNamed(AppRoutes.home);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("Login", true);

  }
}
