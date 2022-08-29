import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../controller/LacaleString.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/language_controller.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

enum Languages { hindi, english, gujarati }

class _LanguageState extends State<Language> {
  final LanguageController languageController = Get.put(LanguageController());

  Languages? _language = Languages.english;

  late SharedPreferences prefs;

  bool eng = true;
  bool hin = false;
  bool guj = false;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            languagesDetails(),
          ],
        ),
      ),
    );
  }

  languagesDetails() {
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
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 0, left: 0, bottom: 20, top: 0),
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
                        text: LocaleString().changeLan.tr,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().changeLan.tr,
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    fields(
                        msg: 'हिन्दी',
                        lang: languageController.isHindi.value,
                        val: Languages.hindi,
                        index: 1),
                    fields(
                        msg: 'English',
                        lang: languageController.isEnglish.value,
                        val: Languages.english,
                        index: 2),
                    fields(
                        msg: 'ગુજરાતી',
                        lang: languageController.isGujarati.value,
                        val: Languages.gujarati,
                        index: 3),
                    doneButton(),
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

  fields(
      {required String msg,
      required bool lang,
      required val,
      required int index}) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          languageController.i.value = index;
          _language = val;
          lang = true;
          print('$msg : $lang');
          if (msg == 'English') {
            setState(() {
              getSharedPreferences();
              prefs.setBool("English", true);
              prefs.setBool("Hindi", false);
              prefs.setBool("Gujarati", false);
            });
          }
          if (msg == 'हिन्दी') {
            setState(() {
              getSharedPreferences();
              prefs.setBool("English", false);
              prefs.setBool("Hindi", true);
              prefs.setBool("Gujarati", false);
            });
          }
          if (msg == 'ગુજરાતી') {
            setState(() {
              getSharedPreferences();
              prefs.setBool("English", false);
              prefs.setBool("Hindi", false);
              prefs.setBool("Gujarati", true);
            });
          }
          setState(() {
            isE = prefs.getBool("English")!;
            isH = prefs.getBool("Hindi")!;
            isG = prefs.getBool("Gujarati")!;
          });
        },
        child: Container(
          height: SizeData.height * 0.055,
          margin: const EdgeInsets.only(left: 20, top: 25, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (languageController.i.value == index)
                      ? AppColors.blue
                      : AppColors.borderColor,
                  width: 2)),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 0),
            child: Row(
              children: [
                Radio<Languages>(
                  activeColor: (languageController.i.value == index)
                ? MaterialStateColor.resolveWith((states) => AppColors.blue)
                : MaterialStateColor.resolveWith((states) => AppColors.borderColor),
                  fillColor: (languageController.i.value == index)
                      ? MaterialStateColor.resolveWith((states) => AppColors.blue)
                      : MaterialStateColor.resolveWith((states) => AppColors.borderColor),
                  value: _language!,
                  groupValue: _language,
                  onChanged: (value) {
                    languageController.i.value = index;
                    setState(() {
                      _language = value;
                    });
                    lang = true;
                    languageController.mySelectedLanguage.value =
                        value.toString();
                  },
                ),
                GlobalText(
                  text: msg,
                  color: (languageController.i.value == index)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).hintColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  closeButton() {
    return Padding(
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
    );
  }

  doneButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.blue,
          fixedSize: Size(SizeData.width * 0.7, 45),
        ),
        onPressed: () {
          if (_language == Languages.english) {
            var locale = const Locale('en', 'US');
            Get.updateLocale(locale);
          } else if (_language == Languages.hindi) {
            var locale = const Locale('hi', 'IN');
            Get.updateLocale(locale);
          } else if (_language == Languages.gujarati) {
            var locale = const Locale('gu', 'IN');
            Get.updateLocale(locale);
          }
        },
        child: GlobalText(
          text: LocaleString().changeLan.tr,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
