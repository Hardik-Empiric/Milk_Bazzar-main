import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/models/login_models/loginModels.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/app_colors.dart';
import '../../language/controller/LacaleString.dart';
import '../../login/controller/login_controller.dart';

late Timer timer;

class OtpController extends GetxController {
  RxBool isPinPut = false.obs;

  RxInt counter = 60.obs;

  RxBool isResend = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  verifyOTP({required String vid, required String smsCode}) async {
    List numbers = [];

    var customers =
        await FirebaseFirestore.instance.collection('customers').get();

    var merchants =
        await FirebaseFirestore.instance.collection('merchants').get();

    for (var docs in customers.docs) {
      Map<String, dynamic> data = docs.data();
      numbers.add(data["number"]);
    }

    for (var docs in merchants.docs) {
      Map<String, dynamic> data = docs.data();
      numbers.add(data["number"]);
    }

    final OtpController otpVerificationController = Get.put(OtpController());
    timer.cancel();
    otpVerificationController.counter.value = 0;

    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: vid, smsCode: smsCode);

    await auth.signInWithCredential(credential);
    //
    // Get.snackbar(LocaleString().correctOTP.tr, LocaleString().loginSuccess.tr,
    //     backgroundColor: AppColors.darkBlue, colorText: AppColors.white);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    var name = await FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!numbers.contains(LoginModels.phone.toString())) {

      (prefs.getBool("isMerchant") ?? false)
          ? Get.offAllNamed(AppRoutes.home)
          : Get.offAllNamed(AppRoutes.welcome);
    } else {

      List mer = [];

      for (var docs in merchants.docs) {
        Map<String, dynamic> data = docs.data();
        mer.add(data["number"]);
      }

      (mer.contains(LoginModels.phone.toString()))
          ? Get.offAllNamed(AppRoutes.home)
          : Get.offAllNamed(AppRoutes.welcome);
    }

    prefs.setBool("Login", true);

    if (!numbers.contains(LoginModels.phone.toString())) {
      if (prefs.getBool("isMerchant") ?? false) {
        var user = FirebaseFirestore.instance
            .collection('merchants')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'name': "${LoginModels.name}",
          'number': "${LoginModels.phone}",
          'add': "${LoginModels.address}",
          'type': "merchant",
          'image': "",
          'uid':"${FirebaseAuth.instance.currentUser!.uid}",
         'price_per_liter': LoginModels.rupeesPerLiter,

        });
      } else {
        var user = FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'name': "${LoginModels.name}",
          'number': "${LoginModels.phone}",
          'add': "${LoginModels.address}",
          'type': "customer",
          'image': "",
          'merchant':"",
          'uid':"${FirebaseAuth.instance.currentUser!.uid}",
        });
      }
    }
  }
}
