import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/mode_controller.dart';

class Mode extends StatefulWidget {
  const Mode({Key? key}) : super(key: key);

  @override
  State<Mode> createState() => _ModeState();
}

enum Modes { dark, light }

class _ModeState extends State<Mode> {
  final ModesController modeController = Get.put(ModesController());

  Modes? _mode = Modes.light;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            modeDetails(),
          ],
        ),
      ),
    );
  }

  modeDetails() {
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
                          color: Theme.of(context).primaryColor,
                          text: LocaleString().changeMode.tr,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().selectMode.tr,
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    fields(
                        name: "dark",
                        msg: LocaleString().darkMode.tr,
                        lang: modeController.isDark.value,
                        val: Modes.dark,
                        index: 1),
                    fields(
                        name: "light",
                        msg: LocaleString().lightMode.tr,
                        lang: modeController.isLight.value,
                        val: Modes.light,
                        index: 2),
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
      {required String name,
      required String msg,
      required bool lang,
      required val,
      required int index}) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          modeController.i.value = index;
          _mode = val;
          setState(() {});
        },
        child: Container(
          height: SizeData.height * 0.055,
          margin: const EdgeInsets.only(left: 20, top: 25, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (modeController.i.value == index)
                      ? AppColors.blue
                      : AppColors.borderColor,
                  width: 2)),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 0),
            child: Row(
              children: [
                Radio<Modes>(
                  fillColor: (modeController.i.value == index)
                      ? MaterialStateColor.resolveWith(
                          (states) => AppColors.blue)
                      : MaterialStateColor.resolveWith(
                          (states) => AppColors.borderColor),
                  value: val,
                  groupValue: _mode,
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    modeController.i.value = index;
                    _mode = value;
                    lang = true;
                    modeController.mySelectedMode.value = value.toString();
                  },
                ),
                GlobalText(
                  text: msg,
                  color: (modeController.i.value == index)
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
            height: SizeData.height * 0.04,
            width: SizeData.width * 0.085,
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
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: Theme.of(context).primaryColor,
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
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (_mode == Modes.light) {
            modeController.isDark.value = false;
            prefs.setBool("isDark", false);
          } else if (_mode == Modes.dark) {
            modeController.isDark.value = true;
            prefs.setBool("isDark", true);
          }
        },
        child: GlobalText(
          text: LocaleString().changeMode.tr,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
