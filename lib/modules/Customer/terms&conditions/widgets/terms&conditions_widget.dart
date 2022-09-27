import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/terms&conditions_controller.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

enum TermsConditionss { hindi, english, gujarati }

class _TermsConditionsState extends State<TermsConditions> {
  final TermsConditionsController termsConditionsController =
      Get.put(TermsConditionsController());

  @override
  Widget build(BuildContext context) {
    return termsConditionsDetails();
  }

  termsConditionsDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Expanded(child: closeButton(),flex: 1,),
          Expanded(
            flex: 9,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
            children: [
                  GlobalText(
                    text: LocaleString().termsCondition.tr,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
                    child: GlobalText(
                      text: LocaleString().termsAndConditions.tr,
                      textAlign: TextAlign.center,
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            ],
          ),
                ),
              )),
        ],
      ),
    );
  }

  closeButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, top: 15, bottom: 5),
        child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }
}
