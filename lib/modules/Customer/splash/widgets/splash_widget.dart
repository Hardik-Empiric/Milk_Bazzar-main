import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../language/controller/LacaleString.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: appLogo(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: GlobalText(
              text: LocaleString().milkBazzar.tr,
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
