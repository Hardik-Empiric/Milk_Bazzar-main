import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/modules/Customer/splash/widgets/splash_widget.dart';
import 'package:milk_bazzar/utils/app_constants.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();

    splashController.changePage();
  }

  @override
  Widget build(BuildContext context) {
    SizeData(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SplashView(),
    );
  }
}
