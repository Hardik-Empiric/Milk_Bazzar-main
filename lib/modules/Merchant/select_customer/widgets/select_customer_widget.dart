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
import '../controller/select_customer_controller.dart';

class SelectCustomer extends StatefulWidget {
  const SelectCustomer({Key? key}) : super(key: key);

  @override
  State<SelectCustomer> createState() => _SelectCustomerState();
}

enum Menu { current, previous }

class _SelectCustomerState extends State<SelectCustomer> {
  final SelectCustomerController selectCustomerController =
      Get.put(SelectCustomerController());

  TextEditingController searchController = TextEditingController();

  bool isCheck = false;

  String _selectedMenu = "current";


  var customerList = [];


  @override
  void initState() {
    super.initState();
    selectCustomerController.customerName.value = "";
    selectCustomerController.isCurrentSelected.value = true;
    selectCustomerController.isPreviousSelected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    yearItems.clear();

    for (int i = 1; i < 15; i++) {
      yearItems.add('${DateTime.now().year - i}');
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            SelectCustomerDetails(),
          ],
        ),
      ),
    );
  }

  SelectCustomerDetails() {
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
                          text: LocaleString().selectCustomer.tr,
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
                    doneButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                            isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber
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
                          searchController: searchController,
                          searchInnerWidget: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              controller: searchController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: LocaleString().searchCustomer.tr,
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return (item.value.toString().toLowerCase().contains(searchValue.toLowerCase()));
                          },
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              searchController.clear();
                            }
                          },
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
                            selectCustomerController.customerName.value =
                                value.toString();

                            var uid = await FirebaseFirestore.instance
                                .collection("customers")
                                .where("name",
                                    isEqualTo:
                                        "${selectCustomerController.customerName.value}")
                                .get();

                            print("UID : ${uid.docs[0].id}");

                            selectCustomerController.customerUID.value =
                                "${uid.docs[0].data()["number"]}";
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
            text: selectCustomerController.selectedValue.value,
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
            selectCustomerController.index.value = monthItems.indexOf(value.toString());
            selectCustomerController.month.value = monthItemsInENGLISH[selectCustomerController.index.value];
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
                  text: (selectCustomerController.isCurrentSelected.value)
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
                selectCustomerController.isPreviousSelected.value = false;

                selectCustomerController.isCurrentSelected.value = true;
                if (selectCustomerController.isCurrentSelected.value) {
                  selectCustomerController.isPreviousSelected.value = false;
                }
              } else {
                selectCustomerController.isCurrentSelected.value = false;

                selectCustomerController.isPreviousSelected.value = true;
                if (selectCustomerController.isPreviousSelected.value) {
                  selectCustomerController.isCurrentSelected.value = false;
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
                              value: selectCustomerController
                                  .isCurrentSelected.value,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMenu = Menu.current.name;
                                });
                                selectCustomerController
                                    .isCurrentSelected.value = value!;
                                if (selectCustomerController
                                    .isCurrentSelected.value) {
                                  selectCustomerController
                                      .isPreviousSelected.value = false;
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ),
                        GlobalText(
                          text: selectCustomerController.currentYear.toString(),
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
                              value: selectCustomerController
                                  .isPreviousSelected.value,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMenu = Menu.previous.name;
                                });
                                selectCustomerController
                                    .isPreviousSelected.value = value!;
                                if (selectCustomerController
                                    .isPreviousSelected.value) {
                                  selectCustomerController
                                      .isCurrentSelected.value = false;
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ),
                        GlobalText(
                          text:
                              selectCustomerController.previousYear.toString(),
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
          if(selectCustomerController.customerName != "")
            {
              Get.toNamed(AppRoutes.generateBillMerchant,
                  arguments: DATA(
                    year: (_selectedMenu.toString() == 'current')
                        ? DateTime.now().year.toString()
                        : (DateTime.now().year - 1).toString(),
                    month: selectCustomerController.month.value,
                    uid: selectCustomerController.customerUID.value,
                  ));
            }
          else
            {
              Get.snackbar(LocaleString().opps.tr, LocaleString().oppsMsg.tr,
                  backgroundColor: AppColors.darkBlue,
                  colorText: AppColors.white);
            }
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
