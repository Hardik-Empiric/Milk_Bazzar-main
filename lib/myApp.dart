import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:milk_bazzar/routes/app_pages.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/Customer/language/controller/LacaleString.dart';
import 'modules/Customer/language/controller/language_controller.dart';
import 'modules/Customer/mode/controller/mode_controller.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final ModesController modeController = Get.put(ModesController());
  final LanguageController languageController = Get.put(LanguageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefs.then((prefs) {
      modeController.isDark.value = prefs.getBool("isDark") ?? false;
      languageController.i.value = (prefs.getBool("English") ?? false)
          ? 2
          : (prefs.getBool("Hindi") ?? false)
              ? 1
              : 3;

      modeController.i.value = (prefs.getBool("isDark") ?? false) ? 1 : 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        theme: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(color: AppColors.black, fontSize: 30),
              pickerTextStyle: TextStyle(color: AppColors.black, fontSize: 20),
            ),
          ),
          hintColor: AppColors.label,
          canvasColor: AppColors.white,
          backgroundColor: AppColors.white,
          primaryColor: AppColors.black,
          cardColor: AppColors.white,
        ),
        darkTheme: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(color: AppColors.white, fontSize: 30),
              pickerTextStyle: TextStyle(color: AppColors.white, fontSize: 20),
            ),
          ),
          hintColor: AppColors.textColor1,
          canvasColor: AppColors.black,
          backgroundColor: AppColors.black,
          primaryColor: AppColors.white,
          cardColor: AppColors.black,
        ),

        themeMode: (modeController.isDark.value) ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppPages.initialRoutes,
        translations: LocaleString(),
        debugShowCheckedModeBanner: false,
        transitionDuration: const Duration(milliseconds: 300),
        getPages: AppPages.routes,
        builder: (context, widget) => ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget!),
          breakpoints: const [
            ResponsiveBreakpoint.resize(350, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ],
        ),
      ),
    );
  }
}
