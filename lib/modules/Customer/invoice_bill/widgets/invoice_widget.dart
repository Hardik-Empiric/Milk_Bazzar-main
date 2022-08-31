import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Merchant/select_customer/controller/select_customer_controller.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/invoive_controller.dart';
import 'package:quiver/time.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

enum Menu { current, previous }

class _InvoiceState extends State<Invoice> {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  bool isCheck = false;

  String _selectedMenu = Menu.current.name;

  int index = 0;

  final List<String> monthItems = [
    LocaleString().jan.tr,
    LocaleString().feb.tr,
    LocaleString().mar.tr,
    LocaleString().apr.tr,
    LocaleString().may.tr,
    LocaleString().jun.tr,
    LocaleString().jul.tr,
    LocaleString().aug.tr,
    LocaleString().sep.tr,
    LocaleString().oct.tr,
    LocaleString().nov.tr,
    LocaleString().dec.tr,
  ];

  final List<String> monthItemsInENGLISH = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            invoiceDetails(),
          ],
        ),
      ),
    );
  }

  invoiceDetails() {
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: appLogo(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: GlobalText(
                          color: Theme.of(context).primaryColor,
                          text: LocaleString().viewInvoiceBill.tr,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().selectMonthYearText.tr,
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    monthPicker(),
                    yearPicker(),
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

  monthPicker() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
      child: Container(
        color: Theme.of(context).backgroundColor,
        // color: Colors.pink,
        child: DropdownButtonFormField2(
          // buttonWidth: SizeData.width * 0.8,
          barrierDismissible: true,
          decoration: InputDecoration(
            fillColor: Colors.black,
            //Add isDense true and zero Padding.
            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            //Add more decoration as you want here
            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
          ),
          hint: GlobalText(
            text: invoiceController.selectedValue.value,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          icon: const CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.borderColor,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.darkBlue,
              size: 20,
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          iconSize: 30,
          buttonHeight: SizeData.height * 0.055,
          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),

          items: monthItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            invoiceController.selectedValue.value = value.toString();

            setState(() {
              index = monthItems.indexOf(value.toString());
            });

            print(index);

            print(monthItemsInENGLISH[index]);

            invoiceController.month.value = monthItemsInENGLISH[index];
            //Do something when changing the item if you want.
          },
          onSaved: (value) {},
        ),
      ),
    );
  }


  yearPicker() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: PopupMenuButton<Menu>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          position: PopupMenuPosition.under,
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: AppColors.borderColor),
            ),
            height: SizeData.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlobalText(
                  text: (invoiceController.isCurrentSelected.value)
                      ? DateTime.now().year.toString()
                      : (DateTime.now().year - 1).toString(),
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.borderColor,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.darkBlue,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          // Callback that sets the selected popup menu item.
          onSelected: (Menu item) {
            setState(() {
              _selectedMenu = item.name.toString();
              if (_selectedMenu == 'current') {
                invoiceController.isPreviousSelected.value = false;

                invoiceController.isCurrentSelected.value = true;
                if (invoiceController.isCurrentSelected.value) {
                  invoiceController.isPreviousSelected.value = false;
                }
              } else {
                invoiceController.isCurrentSelected.value = false;

                invoiceController.isPreviousSelected.value = true;
                if (invoiceController.isPreviousSelected.value) {
                  invoiceController.isCurrentSelected.value = false;
                }
              }
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
            PopupMenuItem<Menu>(
              value: Menu.current,
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
                          value: invoiceController
                              .isCurrentSelected.value,
                          onChanged: (value) {
                            setState(() {
                              _selectedMenu = Menu.current.name;
                            });
                            invoiceController
                                .isCurrentSelected.value = value!;
                            if (invoiceController
                                .isCurrentSelected.value) {
                              invoiceController
                                  .isPreviousSelected.value = false;
                            }
                            Get.back();
                          },
                        ),
                      ),
                    ),
                    GlobalText(
                      text: invoiceController.currentYear.toString(),
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<Menu>(
              value: Menu.previous,
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
                          value: invoiceController
                              .isPreviousSelected.value,
                          onChanged: (value) {
                            setState(() {
                              _selectedMenu = Menu.previous.name;
                            });
                            invoiceController
                                .isPreviousSelected.value = value!;
                            if (invoiceController
                                .isPreviousSelected.value) {
                              invoiceController
                                  .isCurrentSelected.value = false;
                            }
                            Get.back();
                          },
                        ),
                      ),
                    ),
                    GlobalText(
                      text:
                      invoiceController.previousYear.toString(),
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
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.blue,
          fixedSize: Size(SizeData.width * 0.7, 45),
        ),
        onPressed: () {
          Get.toNamed(
            AppRoutes.generateBill,
            arguments: DATA(
              uid: "${FirebaseAuth.instance.currentUser!.phoneNumber}",
              month: "${invoiceController.month.value}",
              year: (_selectedMenu.toString() == 'current')
                  ? DateTime.now().year.toString()
                  : (DateTime.now().year - 1).toString(),
            ),
          );

          print("UID : ${FirebaseAuth.instance.currentUser!.uid}");
          print("MONTH : ${invoiceController.month.value}");
          (_selectedMenu.toString() == 'current')
              ? print("YEAR : ${DateTime.now().year.toString()}")
              : print("YEAR : ${(DateTime.now().year - 1).toString()}");
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
