import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/login_models/loginModels.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_functions/common_functions.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import 'package:get/get.dart';

import '../../language/controller/LacaleString.dart';
import '../controller/login_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final LoginController loginController = Get.put(LoginController());

  final GlobalKey<FormState> _globalFromKey = GlobalKey<FormState>();

  late TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController prizePerLiterController = TextEditingController();

  List numbers = [];
  List allCusName = [];

  var data;


  getAllData() async {

    var cc = await FirebaseFirestore.instance
        .collection('customers')
        .get();

    var mm = await FirebaseFirestore.instance
        .collection('merchants')
        .get();

    cc.docs.forEach((element) {
      allCusName.add(element.data()["name"].toString().toLowerCase());
    });

    mm.docs.forEach((element) {
      allCusName.add(element.data()["name"].toString().toLowerCase());

    });

    allCusName.forEach((element) {
      log(element);
    });
  }

  getList() async {
    var customers = await FirebaseFirestore.instance
        .collection('customers')
        .get();

    var merchants = await FirebaseFirestore.instance
        .collection('merchants')
        .get();

    for (var docs in customers.docs) {
      Map<String, dynamic> data = docs.data();
      numbers.add(data["number"]);
    }

    for (var docs in merchants.docs) {
      Map<String, dynamic> data = docs.data();
      numbers.add(data["number"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          singUpProcess(),
          goToSignIn(),
        ],
      ),
    );
  }

  singUpProcess() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: const Offset(0, 0),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: appLogo(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlobalText(
                      color: Theme.of(context).primaryColor,
                      text: LocaleString().getStartedText.tr,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                GlobalText(
                    text: LocaleString().formHintText.tr,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w500),

                // TODO: Implement Form here

                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Form(
                    key: _globalFromKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return LocaleString().errorName.tr;
                            }
                            if(allCusName.contains(val.toLowerCase()))
                            {
                              return "name is already exist";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            LoginModels.name = val!;
                          },
                          controller: fullNameController,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Graphik"),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              labelText: LocaleString().fullName.tr,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Graphik"),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: AppColors.pendingAmountColor,
                                    width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: AppColors.blue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: AppColors.borderColor, width: 2),
                              ),
                              hintText: LocaleString().enterYourFullName.tr,
                              hintStyle: const TextStyle(
                                color: AppColors.hintTextColor,
                                fontSize: 13,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).backgroundColor,
                                    border: Border.all(
                                        color: AppColors.borderColor,
                                        width: 2)),
                                child: countryCodePicker(context),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 12,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return LocaleString().errorPhone.tr;
                                  }
                                  else if(numbers.contains(val))
                                    {
                                      return "Number is Already register...";
                                    }
                                  return null;
                                },
                                onSaved: (val) {
                                  LoginModels.phone = int.parse(val!);
                                },
                                enableInteractiveSelection: false,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                controller: phoneController,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Graphik"),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    labelText: LocaleString().phone.tr,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: AppColors.pendingAmountColor,
                                          width: 2),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Graphik"),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: AppColors.blue, width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: AppColors.borderColor,
                                          width: 2),
                                    ),
                                    hintText: LocaleString().phoneNumber.tr,
                                    hintStyle: const TextStyle(
                                      color: AppColors.hintTextColor,
                                      fontSize: 13,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return LocaleString().errorAddress.tr;
                            }
                            return null;
                          },
                          onSaved: (val) {
                            LoginModels.address = val;
                          },
                          maxLines: 5,
                          controller: addressController,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Graphik"),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              labelText: LocaleString().address.tr,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: AppColors.pendingAmountColor,
                                    width: 2),
                              ),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Graphik"),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: AppColors.blue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: AppColors.borderColor, width: 2),
                              ),
                              hintText: LocaleString().enterHomeAddress.tr,
                              hintStyle: const TextStyle(
                                color: AppColors.hintTextColor,
                                fontSize: 13,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                        ),
                        (loginController.isMerchant.value) ? Padding(
                            padding: const EdgeInsets.only(top: 30,right: 65,left: 65),
                            child: TextFormField(
                              validator: (val) {
                                    if (val!.isEmpty) {
                                      return LocaleString().errorPrizePerLiter.tr;
                                    }
                                    return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: prizePerLiterController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Graphik"),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  labelText: LocaleString().rupeesPerLiter.tr,
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Graphik"),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: AppColors.pendingAmountColor,
                                        width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: AppColors.blue, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: AppColors.borderColor, width: 2),
                                  ),
                                  // prefix: GlobalText(text: "₹",color: AppColors.hintTextColor,fontSize: 25),
                                  prefixText: "₹",
                                  prefixStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,fontSize: 20,
                                  ),
                                  hintText: LocaleString().enterYourRupees.tr,
                                  hintStyle: const TextStyle(
                                    color: AppColors.hintTextColor,
                                    fontSize: 13,
                                  ),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                            ),
                          ) : Container(),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Transform.scale(
                                scale: 1.5,
                                child: Checkbox(
                                  side: const BorderSide(
                                      width: 1, color: AppColors.borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  activeColor: AppColors.blue,
                                  checkColor: AppColors.background,
                                  value: loginController.isChecked.value,
                                  onChanged: (value) {
                                    loginController.isChecked.value = value!;
                                    LoginModels.isChecked = value;
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      LocaleString().iAgreeCheckBoxTextPart1.tr,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: LocaleString()
                                          .iAgreeCheckBoxTextPart2
                                          .tr,
                                      style: const TextStyle(
                                        color: AppColors.darkBlue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: LocaleString().and.tr,
                                    ),
                                    TextSpan(
                                      text: LocaleString()
                                          .iAgreeCheckBoxTextPart3
                                          .tr,
                                      style: const TextStyle(
                                        color: AppColors.darkBlue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.blue,
                      fixedSize: Size(SizeData.width * 0.7, 45),
                    ),
                    onPressed: () async {
                      if (_globalFromKey.currentState!.validate()) {

                        _globalFromKey.currentState!.save();

                        LoginModels.name = fullNameController.text;
                        LoginModels.phone = int.parse(phoneController.text);
                        LoginModels.address = addressController.text;
                        LoginModels.isChecked = loginController.isChecked.value;
                        LoginModels.rupeesPerLiter = double.parse(prizePerLiterController.text.isEmpty ? "0" : prizePerLiterController.text);

                            if (loginController.isChecked.value) {
                              Get.toNamed(AppRoutes.otpVerification);

                              loginController.sendOtp(phone: phoneController.text);
                            } else {
                              Get.snackbar(
                                LocaleString().errorCheck.tr,
                                LocaleString().errorCheck.tr,
                                backgroundColor: AppColors.darkBlue,
                              );
                            }
                      }
                    },
                    child: GlobalText(
                      text: LocaleString().singUp.tr,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                          () => Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: const BorderSide(
                              width: 1, color: AppColors.borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: AppColors.blue,
                          checkColor: AppColors.background,
                          value: loginController.isMerchant.value,
                          onChanged: (value) async {
                            setState(() {
                              loginController.isMerchant.value = value!;
                            });
                            LoginModels.isMerchant = value;

                            SharedPreferences prefs = await SharedPreferences.getInstance();

                            prefs.setBool("isMerchant", loginController.isMerchant.value);

                          },
                        ),
                      ),
                    ),
                    Expanded(
                        child: GlobalText(
                          text: LocaleString().signUpAsMerchant.tr,
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToSignIn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GlobalText(
            text: LocaleString().alreadyAccount.tr,
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.register);
            },
            child: GlobalText(
              text: LocaleString().singIn.tr,
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
