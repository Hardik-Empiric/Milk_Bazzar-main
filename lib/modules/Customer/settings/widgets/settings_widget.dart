import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Merchant/home/controller/home_controller.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/settings_controller.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController settingsController = Get.put(SettingsController());
  final HomeController homeController = Get.put(HomeController());

  bool isMerchant = true;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isMerchant = prefs.getBool("isMerchant")??false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            SettingsDetails(),
          ],
        ),
      ),
    );
  }

  SettingsDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
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
                  const EdgeInsets.only(right: 0, left: 0, bottom: 15, top: 0),
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
                          color: Theme.of(context).primaryColor,
                          text: LocaleString().settings.tr,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().settingHintText.tr,
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    advanceFields(
                        alignment: const Alignment(-0.75, -0.95),
                        name: LocaleString().profile.tr,
                        msg: LocaleString().profileMsg.tr,
                        navigatorPageName: AppRoutes.profile),
                    advanceFields(
                        alignment: const Alignment(-0.65, -0.95),
                        name: LocaleString().termsCondition.tr,
                        msg: LocaleString().termsCondition.tr,
                        navigatorPageName: AppRoutes.termsConditions),
                    advanceFields(
                        alignment: const Alignment(-0.75, -0.95),
                        name: LocaleString().language.tr,
                        msg: LocaleString().languageMsg.tr,
                        navigatorPageName: AppRoutes.language),
                    normalFields(
                        msg: LocaleString().mode.tr,
                        navigatorPageName: AppRoutes.mode),
                    normalFields(
                        msg: LocaleString().logout.tr,
                        navigatorPageName: AppRoutes.register),
                  ],
                ),
              ),
            ),
          ),
          closeButton(),
        ],
      ),
    );
  }

  closeButton() {
    return Visibility(
      visible: !isMerchant,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.5),
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  Icons.close_rounded,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
              )),
        ),
      ),
    );
  }

  normalFields({required String msg, required String navigatorPageName}) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();


        if (msg == LocaleString().logout.tr) {
          Get.defaultDialog(
            onCancel: () {

                    if(prefs.getBool("isMerchant") == true)
                      {
                        homeController.index.value = 4;
                      }
                    else
                      {
                        Get.toNamed(AppRoutes.settings);
                      }
            },
            onConfirm: () async {
              await FirebaseAuth.instance.signOut();

              prefs.setBool("isMerchant", false);

              prefs.setBool("Login", false);

              Get.offAllNamed(navigatorPageName);
            },
            title: LocaleString().areYouSure.tr,
            backgroundColor:Theme.of(context).backgroundColor,
            titleStyle: TextStyle(color: AppColors.darkBlue),
            middleTextStyle: TextStyle(color: Theme.of(context).backgroundColor),
            textConfirm: LocaleString().yes.tr,
            textCancel: LocaleString().no.tr,
            cancelTextColor: Theme.of(context).primaryColor,
            confirmTextColor: Theme.of(context).backgroundColor,
            buttonColor: AppColors.blue,
            barrierDismissible: false,
            radius: 50,
            content: Text(LocaleString().wantToLogout.tr,style: TextStyle(color: Theme.of(context).primaryColor),),
          );
        } else {
          Get.toNamed(navigatorPageName);
        }
      },
      child: Container(
        height: SizeData.height * 0.06,
        margin: (msg == AppTexts.logout)
            ? const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 0)
            : const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.borderColor, width: 2)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalText(
                text: msg,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
              (msg == LocaleString().mode.tr)
                  ? const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.borderColor,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.blue,
                        size: 12,
                      ),
                    )
                  : const Icon(
                      Icons.logout,
                      color: AppColors.blue,
                      size: 25,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  advanceFields(
      {required String name,
      required Alignment alignment,
      required String msg,
      required String navigatorPageName}) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        bool isMerchant = prefs.getBool("isMerchant")??false;
        if(navigatorPageName == AppRoutes.profile)
          {
            Get.toNamed(navigatorPageName,arguments: isMerchant);
          }
        else
          {
            Get.toNamed(navigatorPageName);
          }
      },
      child: Stack(
        alignment: alignment,
        children: [
          Container(
            height: SizeData.height * 0.06,
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.borderColor, width: 2)),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalText(
                    text: msg,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  (name != AppTexts.profile)
                      ? const CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.borderColor,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.blue,
                            size: 12,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.all(4),
            child: GlobalText(
              text: name,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  doneButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.blue,
          fixedSize: Size(SizeData.width * 0.7, 45),
        ),
        onPressed: () {},
        child: GlobalText(
          text: AppTexts.done,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
