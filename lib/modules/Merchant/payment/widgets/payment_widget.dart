import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../controller/payment_controller.dart';
import '../controller/payment_controller.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

enum Menu { current, previous }

class _PaymentState extends State<Payment> {
  final PaymentController paymentController =
  Get.put(PaymentController());

  TextEditingController paymentOfMonthController = TextEditingController();

  bool isCheck = false;

  String _selectedMenu = "current";

  var customerList = [];

  @override
  void initState() {
    super.initState();
    paymentController.customerName.value = "";
    paymentController.isCurrentSelected.value = true;
    paymentController.isPreviousSelected.value = false;
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            PaymentDetails(),
          ],
        ),
      ),
    );
  }

  PaymentDetails() {
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
                          text: LocaleString().addPayment.tr,
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
                    selectCustomer(
                      name: LocaleString().customer.tr,
                      msg: LocaleString().selectCustomer.tr,
                      icon: Icons.keyboard_arrow_down_rounded,
                    ),
                    monthPicker(),
                    yearPicker(),
                    paymentTextField(),
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

  selectCustomer({
    required String name,
    required String msg,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Stack(
          alignment: Alignment(-0.9, -0.95),
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("customers")
                        .where("merchant",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid
                            .toString())
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                      if (snapshots.hasData) {
                        customerList = snapshots.data!.docs;

                        return DropdownButtonFormField2(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          isExpanded: true,
                          hint: GlobalText(
                            text: msg,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.darkGrey,
                          ),
                          icon: CircleAvatar(
                            radius: 10,
                            backgroundColor: AppColors.borderColor,
                            child: Icon(
                              icon,
                              color: AppColors.blue,
                              size: 20,
                            ),
                          ),
                          iconSize: 30,
                          buttonHeight: 50,
                          items: customerList.map((item) {
                            return DropdownMenuItem<String>(
                              value: item["name"].toString(),
                              child: Text(
                                item["name"].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select customer.';
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            //Do something when changing the item if you want.
                            paymentController.customerName.value =
                                value.toString();

                            var uid = await FirebaseFirestore.instance
                                .collection("customers")
                                .where("name",
                                isEqualTo:
                                "${paymentController.customerName.value}")
                                .get();

                            print("UID : ${uid.docs[0].id}");

                            paymentController.customerUID.value =
                            "${uid.docs[0].id}";
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
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
      ),
    );
  }

  monthPicker() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
      child: Container(
        color: Theme.of(context).backgroundColor,
        height: SizeData.height * 0.055,
        child: DropdownButtonFormField2(
          buttonWidth: SizeData.width * 0.8,
          barrierDismissible: true,
          decoration: InputDecoration(
            //Add isDense true and zero Padding.
            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderSide:
              const BorderSide(width: 2, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(width: 2, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(width: 2, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(width: 2, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(width: 2, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            //Add more decoration as you want here
            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
          ),
          isExpanded: false,
          hint: GlobalText(
            text: paymentController.selectedValue.value,
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
          buttonHeight: 60,
          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          items: monthItems
              .map((item) {
            return DropdownMenuItem<String>(

              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            );})
              .toList(),
          onChanged: (value) {
            //Do something when changing the item if you want.
            paymentController.index.value = monthItems.indexOf(value.toString());
            paymentController.month.value = monthItemsInENGLISH[paymentController.index.value];
          },
          onSaved: (value) {

          },
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
                  text: (paymentController.isCurrentSelected.value)
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
                paymentController.isPreviousSelected.value = false;

                paymentController.isCurrentSelected.value = true;
                if (paymentController.isCurrentSelected.value) {
                  paymentController.isPreviousSelected.value = false;
                }
              } else {
                paymentController.isCurrentSelected.value = false;

                paymentController.isPreviousSelected.value = true;
                if (paymentController.isPreviousSelected.value) {
                  paymentController.isCurrentSelected.value = false;
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
                          value: paymentController
                              .isCurrentSelected.value,
                          onChanged: (value) {
                            setState(() {
                              _selectedMenu = Menu.current.name;
                            });
                            paymentController
                                .isCurrentSelected.value = value!;
                            if (paymentController
                                .isCurrentSelected.value) {
                              paymentController
                                  .isPreviousSelected.value = false;
                            }
                            Get.back();
                          },
                        ),
                      ),
                    ),
                    GlobalText(
                      text: paymentController.currentYear.toString(),
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
                          value: paymentController
                              .isPreviousSelected.value,
                          onChanged: (value) {
                            setState(() {
                              _selectedMenu = Menu.previous.name;
                            });
                            paymentController
                                .isPreviousSelected.value = value!;
                            if (paymentController
                                .isPreviousSelected.value) {
                              paymentController
                                  .isCurrentSelected.value = false;
                            }
                            Get.back();
                          },
                        ),
                      ),
                    ),
                    GlobalText(
                      text:
                      paymentController.previousYear.toString(),
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

  paymentTextField(){
    return  Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return LocaleString().errorPrisePerMonth.tr;
            }
            return null;
          },
          keyboardType: TextInputType.number,
          controller: paymentOfMonthController,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: "Graphik"),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              label: Center(
                child: GlobalText(
                  text: LocaleString().rupeesPerMonth.tr,
                  color: Theme.of(context).hintColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                    color: AppColors.pendingAmountColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:
                const BorderSide(color: AppColors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                    color: AppColors.borderColor, width: 2),
              ),
              // prefix: GlobalText(text: "₹",color: AppColors.hintTextColor,fontSize: 25),
              prefixText: "₹",
              prefixStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
              hintText: LocaleString().enterYourRupees.tr,
              hintStyle: const TextStyle(
                color: AppColors.hintTextColor,
                fontSize: 13,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always),
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

          (_selectedMenu.toString() == 'current')
              ? print("Year : ${DateTime.now().year.toString()}")
              : print("Year : ${(DateTime.now().year - 1).toString()}");
           print("Month : ${paymentController.month.value}");
           print("CustomerUID : ${paymentController.customerUID.value}");
           print("Rupees : ${paymentOfMonthController.text}");

        },
        child: GlobalText(
          text: LocaleString().addPayment.tr,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}