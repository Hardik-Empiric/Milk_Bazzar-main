import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/login_models/loginModels.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/welcome_controller.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final WelcomeController welcomeController = Get.put(WelcomeController());

  getData() async {
    var name = await FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.phoneNumber).get();

    setState(() {
      LoginModels.name = name.data()!['name'];
    });
  }

  late String wish;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();



    setState(() {
      int hour = DateTime.now().hour;

      if(hour > 4 && hour < 12)
      {
        wish = LocaleString().goodMorning.tr;
      }
      else if(hour >= 12 && hour < 17)
      {
        wish = LocaleString().goodAfternoon.tr;
      }
      else if(hour >= 17 && hour < 22)
      {
        wish = LocaleString().goodEvening.tr;
      }
      else
      {
        wish = LocaleString().goodNight.tr;
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      int hour = DateTime.now().hour;

      if(hour > 4 && hour < 12)
      {
        wish = LocaleString().goodMorning.tr;
      }
      else if(hour >= 12 && hour < 17)
      {
        wish = LocaleString().goodAfternoon.tr;
      }
      else if(hour >= 17 && hour < 22)
      {
        wish = LocaleString().goodEvening.tr;
      }
      else
      {
        wish = LocaleString().goodNight.tr;
      }
    });
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            welcomeDetails(),
          ],
        ),
      ),
    );
  }

  welcomeDetails() {
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
              boxShadow:  [
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
                    Padding(padding: EdgeInsets.all(10),child: appLogo(),),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: GlobalText(
                          text: "${wish} ${ LoginModels.name.split(" ")[0]}",
                          // text: "${LocaleString().goodMorning.tr} ${ LoginModels.name.split(" ")[0]}",
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().welcomeMsg.tr,
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    fields(msg: LocaleString().invoiceBill.tr,navigatorPageName: AppRoutes.invoice),
                    fields(msg: LocaleString().settings.tr,navigatorPageName: AppRoutes.settings),
                    // doneButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fields({required String msg, required String navigatorPageName}) {
    return GestureDetector(
      onTap: (){

        Get.toNamed(navigatorPageName);

      },
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.borderColor, width: 2)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalText(
                text: msg,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
                fontSize: 13,
              ),
              const CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.borderColor,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.darkBlue,
                  size: 12,
                ),
              )
            ],
          ),
        ),
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
        onPressed: () {
        },
        child: GlobalText(
          text: LocaleString().done.tr,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
