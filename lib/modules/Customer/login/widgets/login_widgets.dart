import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List numbers = [];

  getList() async {
    var len = await FirebaseFirestore.instance
        .collection('customers')
        .get();

    print(len.docs.length);
    for (var docs in len.docs) {
      Map<String, dynamic> data = docs.data();
      numbers.add(data["number"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
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
                )
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
