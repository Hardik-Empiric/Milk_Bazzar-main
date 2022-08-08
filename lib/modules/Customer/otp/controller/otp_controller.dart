import 'package:cloud_firestore/cloud_firestore.dart';
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

    Get.offAllNamed(AppRoutes.welcome);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("Login", true);

    List numbers = [];

      var len = await FirebaseFirestore.instance
          .collection('customers')
          .get();

      print(len.docs.length);
      for (var docs in len.docs) {
        Map<String, dynamic> data = docs.data();
        numbers.add(data["number"]);
    }

      if(!numbers.contains(LoginModels.phone.toString()))
        {

          var user = FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).set(
              {
                'name':"${LoginModels.name}",
                'number':"${LoginModels.phone}",
                'add':"${LoginModels.address}",
                'type':"customer",
                'image' : "",
              });

        }

  }
}



