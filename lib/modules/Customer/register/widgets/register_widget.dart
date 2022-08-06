import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/login_models/loginModels.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_functions/common_functions.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/register_controller.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RegisterController registerController = Get.put(RegisterController());

  final GlobalKey<FormState> _globalFromKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            fillPhone(),

            getToOtp(),

          ],
        ),
      ),
    );
  }

  fillPhone() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          boxShadow:  [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(0, 0),
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
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: GlobalText(
                    color:  Theme.of(context).primaryColor,
                      text: LocaleString().mobileNumber.tr,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                GlobalText(
                    text: LocaleString().conCode.tr,
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w500),

                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Form(
                    key: _globalFromKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            Expanded(flex: 1,child: Container(),),
                            Expanded(
                              flex: 12,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return LocaleString().errorPhone.tr;
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
                                          color: AppColors
                                              .pendingAmountColor,
                                          width: 2),
                                    ),
                                    labelStyle:  TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Graphik"),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: AppColors.blue,
                                          width: 2),
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
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.blue,
                      fixedSize: Size(SizeData.width * 0.7, 45),
                    ),
                    onPressed: () async {
                      if (_globalFromKey.currentState!.validate()) {
                        _globalFromKey.currentState!.save();

                        LoginModels.phone = int.parse(phoneController.text);

                        Get.toNamed(AppRoutes.otpVerification);

                        registerController.sendOtp(phone: phoneController.text);
                      }
                    },
                    child: GlobalText(
                      text: LocaleString().next.tr,
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

  getToOtp() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GlobalText(
            text: LocaleString().haveNotAnAccount.tr,
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.login);
            },
            child: GlobalText(
              text: LocaleString().singUp.tr,
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
