import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../controller/sell_milk_controller.dart';

class SellMilk extends StatefulWidget {
  const SellMilk({Key? key}) : super(key: key);

  @override
  State<SellMilk> createState() => _SellMilkState();
}

enum Menu { morning, evening }

class _SellMilkState extends State<SellMilk> {
  final SellMilkController sellMilkController = Get.put(SellMilkController());

  bool isCheck = false;

  Duration duration = const Duration(hours: 7, minutes: 00);

  String _selectedMenu = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            SellMilkDetails(),
          ],
        ),
      ),
    );
  }

  SellMilkDetails() {
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
                  const EdgeInsets.only(right: 0, left: 0, bottom: 20, top: 0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    appLogo(width: 0.35, height: 0.20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: GlobalText(
                          color: Theme.of(context).primaryColor,
                          text: LocaleString().sellMilk.tr,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().milkDataAdd.tr,
                        fontSize: 14,
                        color: AppColors.textColor1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    timePicker(
                        name: LocaleString().time.tr,
                        msg: LocaleString().selectTime.tr,
                        onTap: () {
                          _showDialog(CupertinoTimerPicker(
                            backgroundColor: Theme.of(context).backgroundColor,
                            mode: CupertinoTimerPickerMode.hm,
                            initialTimerDuration: duration,
                            // This is called when the user changes the timer duration.
                            onTimerDurationChanged: (Duration newDuration) {
                              setState(() => duration = newDuration);
                            },
                          ),
                          );

                        },
                        icon: Icons.date_range),
                    advancePicker(
                      name: LocaleString().customer.tr,
                      msg: LocaleString().selectCustomer.tr,
                      onTap: () {},
                      icon: Icons.keyboard_arrow_down_rounded,
                    ),
                    sessionPicker(
                      name: LocaleString().session.tr,
                      msg: LocaleString().selectSession.tr,
                      icon: Icons.keyboard_arrow_up_rounded,
                    ),
                    advancePicker(
                      name: LocaleString().liter.tr,
                      msg: LocaleString().selectLiter.tr,
                      onTap: () {},
                      icon: Icons.keyboard_arrow_down_rounded,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          addMilkButton(),
                          cancelButton(),
                        ],
                      ),
                    ),
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

  addMilkButton() {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(right: 30, left: 30)),
        child: GlobalText(
          text: LocaleString().addMilkButtonText.tr,
        ));
  }

  cancelButton() {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(right: 35, left: 35),
          primary: AppColors.lightBlue,
          onPrimary: AppColors.blue,
          elevation: 0,
        ),
        child: GlobalText(
          text: LocaleString().cancelButtonText.tr,
        ));
  }

  advancePicker({
    required String name,
    required String msg,
    required Function() onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Stack(
          alignment: Alignment(-0.9, -0.8),
          children: [
            Container(
              height: SizeData.height * 0.06,
              width: SizeData.width * 0.8,
              margin:
                  const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.borderColor, width: 2)),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: GlobalText(
                        text: msg,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    (name != LocaleString().time.tr)
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: AppColors.borderColor,
                            child: Icon(
                              icon,
                              color: AppColors.blue,
                              size: 20,
                            ),
                          )
                        : Icon(
                            icon,
                            color: AppColors.darkGrey,
                            size: 25,
                          ),
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
                color: AppColors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }

  timePicker({
    required String name,
    required String msg,
    required Function() onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Stack(
          alignment: Alignment(-0.9, -0.8),
          children: [
            Container(
              height: SizeData.height * 0.06,
              width: SizeData.width * 0.8,
              margin:
              const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.borderColor, width: 2)),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: GlobalText(
                        text: "${duration.toString().split(".")[0].split(":")[0]} : ${duration.toString().split(".")[0].split(":")[1]}",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    (name != LocaleString().time.tr)
                        ? CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.borderColor,
                      child: Icon(
                        icon,
                        color: AppColors.blue,
                        size: 20,
                      ),
                    )
                        : Icon(
                      icon,
                      color: AppColors.darkGrey,
                      size: 25,
                    ),
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
                color: AppColors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }

  sessionPicker({
    required String name,
    required String msg,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: PopupMenuButton<Menu>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          position: PopupMenuPosition.under,
          child: Stack(
            alignment: Alignment(-0.9, -0.8),
            children: [
              Container(
                height: SizeData.height * 0.06,
                width: SizeData.width * 0.8,
                margin: const EdgeInsets.only(
                    left: 0, right: 0, bottom: 15, top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.borderColor, width: 2)),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: GlobalText(
                          text: (_selectedMenu.toString() == 'morning')
                              ? LocaleString().morningSession.tr
                              : LocaleString().eveningSession.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      (name != LocaleString().time.tr)
                          ? CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.borderColor,
                              child: Icon(
                                icon,
                                color: AppColors.blue,
                                size: 20,
                              ),
                            )
                          : Icon(
                              icon,
                              color: AppColors.darkGrey,
                              size: 25,
                            ),
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
                  color: AppColors.label,
                ),
              ),
            ],
          ),
          // Callback that sets the selected popup menu item.
          onSelected: (Menu item) {
            setState(() {
              _selectedMenu = item.name.toString();
              if (_selectedMenu == 'morning') {
                sellMilkController.isMorningSelected.value = false;

                sellMilkController.isEveningSelected.value = true;
                if (sellMilkController.isEveningSelected.value) {
                  sellMilkController.isMorningSelected.value = false;
                }
              } else {
                sellMilkController.isEveningSelected.value = false;

                sellMilkController.isMorningSelected.value = true;
                if (sellMilkController.isMorningSelected.value) {
                  sellMilkController.isEveningSelected.value = false;
                }
              }
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                PopupMenuItem<Menu>(
                  value: Menu.morning,
                  child: SizedBox(
                    width: SizeData.width * 0.7,
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: Obx(
                            () => Checkbox(
                              side: const BorderSide(
                                  width: 1.5, color: AppColors.borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              activeColor: AppColors.checkYearColor,
                              checkColor: AppColors.background,
                              value: sellMilkController.isEveningSelected.value,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMenu = Menu.morning.name;
                                });
                                sellMilkController.isEveningSelected.value =
                                    value!;
                                if (sellMilkController
                                    .isEveningSelected.value) {
                                  sellMilkController.isMorningSelected.value =
                                      false;
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ),
                        GlobalText(
                          text: LocaleString().morningSession.tr,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.evening,
                  child: SizedBox(
                    width: SizeData.width * 0.7,
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: Obx(
                            () => Checkbox(
                              side: const BorderSide(
                                  width: 1.5, color: AppColors.borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              activeColor: AppColors.checkYearColor,
                              checkColor: AppColors.background,
                              value: sellMilkController.isMorningSelected.value,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMenu = Menu.evening.name;
                                });
                                sellMilkController.isMorningSelected.value =
                                    value!;
                                if (sellMilkController
                                    .isMorningSelected.value) {
                                  sellMilkController.isEveningSelected.value =
                                      false;
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ),
                        GlobalText(
                          text: LocaleString().eveningSession.tr,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: Theme.of(context).backgroundColor,
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  closeButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {},
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
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.blue,
          fixedSize: Size(SizeData.width * 0.7, 45),
        ),
        onPressed: () {
          Get.toNamed(AppRoutes.customerList);
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
