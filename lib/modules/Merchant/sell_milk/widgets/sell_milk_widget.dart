import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/modules/Merchant/home/controller/home_controller.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
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

  TextEditingController searchController = TextEditingController();

  bool isCheck = false;

  // String sessionMenu = DateTime.now().year.toString();

  String sessionMenu = "morning";

  final _formKey = GlobalKey<FormState>();

  var customerList = [];

  @override
  void initState() {
    super.initState();
    sessionMenu = "morning";
    sellMilkController.liter.value = 0.5;
    sellMilkController.duration.value = "07:00 AM";
    sellMilkController.isMorningSelected.value = true;
    sellMilkController.isEveningSelected.value = false;
    sellMilkController.customerName.value = "";
  }

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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: appLogo(),
                    ),
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
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    timePicker(
                        name: LocaleString().time.tr,
                        msg: LocaleString().selectTime.tr,
                        onTap: () {
                          _showDialog(
                            CupertinoTimerPicker(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              mode: CupertinoTimerPickerMode.hm,
                              initialTimerDuration:
                                  Duration(hours: 7, minutes: 0),
                              // This is called when the user changes the timer duration.
                              onTimerDurationChanged: (Duration newDuration) {
                                var duration = newDuration;
                                duration = newDuration;
                                int hour = int.parse(duration
                                    .toString()
                                    .split(".")[0]
                                    .split(":")[0]);
                                int min = int.parse(duration
                                    .toString()
                                    .split(".")[0]
                                    .split(":")[1]);

                                String rel;

                                if (hour >= 12) {
                                  rel = "PM";
                                  if (hour > 12) {
                                    hour = hour - 12;
                                  }
                                } else {
                                  rel = "AM";
                                }

                                String finalHour = "";
                                String finalMin = "";

                                if (hour < 10) {
                                  finalHour = "0$hour";
                                } else {
                                  finalHour = "$hour";
                                }

                                if (min < 10) {
                                  finalMin = "0$min";
                                } else {
                                  finalMin = "$min";
                                }

                                print("$finalHour:$finalMin $rel");

                                setState(() {
                                  sellMilkController.duration.value =
                                      "$finalHour:$finalMin $rel";
                                });
                              },
                            ),
                          );
                        },
                        icon: Icons.timer_outlined),
                    selectCustomer(
                      name: LocaleString().customer.tr,
                      msg: LocaleString().selectCustomer.tr,
                      icon: Icons.keyboard_arrow_down_rounded,
                    ),
                    sessionPicker(
                      name: LocaleString().session.tr,
                      msg: LocaleString().selectSession.tr,
                      icon: Icons.keyboard_arrow_up_rounded,
                    ),
                    literPicker(
                      name: LocaleString().liter.tr,
                      msg: LocaleString().selectLiter.tr,
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
        ],
      ),
    );
  }

  addMilkButton() {
    return ElevatedButton(
        onPressed: () async {
          var data = await FirebaseFirestore.instance
              .collection('customers')
              .where("name",
                  isEqualTo: sellMilkController.customerName.value.toString())
              .get();

          List months = [
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

          if (sellMilkController.customerName.value != "" &&
              sellMilkController.liter.value >= 0.5) {
            var ppl = await FirebaseFirestore.instance
                .collection("merchants")
                .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                .get();

            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: Theme.of(context).backgroundColor,
              title: "${LocaleString().sellMilk.tr}",
              titleStyle: TextStyle(color: Theme.of(context).primaryColor),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                      text:
                          "${LocaleString().date.tr} : ${DateTime.now().day}",color: Theme.of(context).primaryColor,),
                  GlobalText(
                      text:
                          "${LocaleString().time.tr} : ${sellMilkController.duration.value}",color: Theme.of(context).primaryColor),
                  (sessionMenu.toString() == 'morning')
                      ? GlobalText(
                          text:
                              "${LocaleString().session.tr} : ${LocaleString().morningSession.tr}",color: Theme.of(context).primaryColor)
                      : GlobalText(
                          text:
                              "${LocaleString().session.tr} : ${LocaleString().eveningSession.tr}",color: Theme.of(context).primaryColor),
                  GlobalText(
                      text:
                          "${LocaleString().liter.tr} : ${sellMilkController.liter.value}",color: Theme.of(context).primaryColor),
                  GlobalText(
                      text:
                          "${LocaleString().PPL.tr} : ${ppl.data()!["price_per_liter"]}",color: Theme.of(context).primaryColor),
                  GlobalText(
                      text:
                          "${LocaleString().customer.tr} : ${sellMilkController.customerName.value}",color: Theme.of(context).primaryColor),
                  GlobalText(
                      text:
                          "${LocaleString().address.tr} : ${data.docs[0]["add"]}",color: Theme.of(context).primaryColor),
                ],
              ),
              confirm: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      sellMilkController.isAdded.value = false;
                    });

                    var data = await FirebaseFirestore.instance
                        .collection("customers")
                        .where("name",
                            isEqualTo: sellMilkController.customerName.value
                                .toString())
                        .get();

                    var DATA = await FirebaseFirestore.instance
                        .collection("customers")
                        .doc(data.docs[0]["number"].toString())
                        .collection("milk_data")
                        .doc("${DateTime.now().year}")
                        .collection("${months[DateTime.now().month - 1]}")
                        .doc("${DateTime.now().day}")
                        .get();

                    var literDATA = await FirebaseFirestore.instance
                        .collection("customers")
                        .doc(data.docs[0]["number"].toString())
                        .collection("milk_data")
                        .doc("${DateTime.now().year}")
                        .collection("${months[DateTime.now().month - 1]}")
                        .doc("total_liter")
                        .get();

                    print("liter DATA : ${literDATA.exists}");

                    List MorningSessionLiter = [];
                    List EveningSessionLiter = [];
                    double MorningSum = 0.0;
                    double EveningSum = 0.0;

                    if (DATA.exists) {
                      print("data exist");

                      if (sessionMenu.toString() == "morning") {
                        MorningSessionLiter =
                            DATA.data()!["${sessionMenu.toString()}"];

                        MorningSessionLiter.add(
                          {
                            "liter": sellMilkController.liter.value,
                            "time": sellMilkController.duration.value,
                          },
                        );

                        for (int i = 0; i < MorningSessionLiter.length; i++) {
                          print(MorningSessionLiter);
                          print(MorningSessionLiter.length);
                          print(MorningSessionLiter[i]["liter"]);
                          setState(() {
                            MorningSum = MorningSum +
                                double.parse(
                                    MorningSessionLiter[i]["liter"].toString());
                          });
                        }

                        await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .doc("${DateTime.now().day}")
                            .update({
                          "${sessionMenu.toString()}": MorningSessionLiter,
                          "total ${sessionMenu.toString()} liter": MorningSum,
                          "ppl": ppl.data()!["price_per_liter"],
                        });

                        List dates = [];

                        var sum = await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .get();

                        sum.docs.forEach((e) {
                          setState(() {
                            if (e.id != "total_liter" &&
                                e.id != "total_price" &&
                                e.id != "received_price")
                              dates.add(int.parse(e.id));
                          });
                        });
                        print("________");
                        print("Dates length : ${dates.length}");
                        print("________");

                        double totalMonthLiter = 0.0;

                        for (int i = 0; i < dates.length; i++) {
                          var monthSum = await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("${dates[i]}")
                              .get();

                          print("=================================");
                          print(monthSum.data()!["total morning liter"]);
                          print(monthSum.data()!["total evening liter"]);
                          print("=================================");

                          setState(() {
                            totalMonthLiter = totalMonthLiter +
                                monthSum.data()!["total morning liter"] +
                                monthSum.data()!["total evening liter"];
                          });
                        }

                        print("+++++++++++++");
                        print("total Month Liter :${totalMonthLiter}");
                        print("+++++++++++++");

                        if (literDATA.exists) {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .update({
                            "liter": totalMonthLiter,
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .set({
                            "liter": totalMonthLiter,
                          });
                        }
                      } else {
                        print("date not exist");

                        EveningSessionLiter =
                            DATA.data()!["${sessionMenu.toString()}"];

                        EveningSessionLiter.add(
                          {
                            "liter": sellMilkController.liter.value,
                            "time": sellMilkController.duration.value,
                          },
                        );

                        for (int i = 0; i < EveningSessionLiter.length; i++) {
                          print(EveningSessionLiter);
                          print(EveningSessionLiter.length);
                          print(EveningSessionLiter[i]["liter"]);
                          setState(() {
                            EveningSum = EveningSum +
                                double.parse(
                                    EveningSessionLiter[i]["liter"].toString());
                          });
                        }

                        await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .doc("${DateTime.now().day}")
                            .update({
                          "${sessionMenu.toString()}": EveningSessionLiter,
                          "total ${sessionMenu.toString()} liter": EveningSum,
                        });

                        List dates = [];

                        var sum = await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .get();

                        sum.docs.forEach((e) {
                          setState(() {
                            if (e.id != "total_liter" &&
                                e.id != "total_price" &&
                                e.id != "received_price")
                              dates.add(int.parse(e.id));
                          });
                        });
                        print("________");
                        print("Dates length : ${dates.length}");
                        print("________");

                        double totalMonthLiter = 0.0;

                        for (int i = 0; i < dates.length; i++) {
                          var monthSum = await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("${dates[i]}")
                              .get();

                          print("=================================");
                          print(monthSum.data()!["total morning liter"]);
                          print(monthSum.data()!["total evening liter"]);
                          print("=================================");

                          setState(() {
                            totalMonthLiter = totalMonthLiter +
                                monthSum.data()!["total morning liter"] +
                                monthSum.data()!["total evening liter"];
                          });
                        }

                        print("+++++++++++++");
                        print("total Month Liter :${totalMonthLiter}");
                        print("+++++++++++++");

                        if (literDATA.exists) {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .update({
                            "liter": totalMonthLiter,
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .set({
                            "liter": totalMonthLiter,
                          });
                        }
                      }
                    } else {
                      if (sessionMenu.toString() == "morning") {
                        await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .doc("${DateTime.now().day}")
                            .set({
                          "${sessionMenu.toString()}": [
                            {
                              "liter": sellMilkController.liter.value,
                              "time": sellMilkController.duration.value,
                            },
                          ],
                          "total ${sessionMenu.toString()} liter":
                              sellMilkController.liter.value,
                          "evening": [],
                          "total evening liter": 0,
                          "ppl": ppl.data()!["price_per_liter"],
                        });
                        List dates = [];

                        var sum = await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .get();

                        sum.docs.forEach((e) {
                          setState(() {
                            if (e.id != "total_liter" &&
                                e.id != "total_price" &&
                                e.id != "received_price")
                              dates.add(int.parse(e.id));
                          });
                        });
                        print("________");
                        print("Dates length : ${dates.length}");
                        print("________");

                        double totalMonthLiter = 0.0;

                        for (int i = 0; i < dates.length; i++) {
                          var monthSum = await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("${dates[i]}")
                              .get();

                          print("=================================");
                          print(monthSum.data()!["total morning liter"]);
                          print(monthSum.data()!["total evening liter"]);
                          print("=================================");

                          setState(() {
                            totalMonthLiter = totalMonthLiter +
                                monthSum.data()!["total morning liter"] +
                                monthSum.data()!["total evening liter"];
                          });
                        }

                        print("+++++++++++++");
                        print("total Month Liter :${totalMonthLiter}");
                        print("+++++++++++++");

                        if (literDATA.exists) {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .update({
                            "liter": totalMonthLiter,
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .set({
                            "liter": totalMonthLiter,
                          });
                        }
                      } else {
                        await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .doc("${DateTime.now().day}")
                            .set({
                          "${sessionMenu.toString()}": [
                            {
                              "liter": sellMilkController.liter.value,
                              "time": sellMilkController.duration.value,
                            },
                          ],
                          "total ${sessionMenu.toString()} liter":
                              sellMilkController.liter.value,
                          "morning": [],
                          "total morning liter": 0,
                          "ppl": ppl.data()!["price_per_liter"],
                        });

                        List dates = [];

                        var sum = await FirebaseFirestore.instance
                            .collection("customers")
                            .doc(data.docs[0]["number"].toString())
                            .collection("milk_data")
                            .doc("${DateTime.now().year}")
                            .collection("${months[DateTime.now().month - 1]}")
                            .get();

                        sum.docs.forEach((e) {
                          setState(() {
                            if (e.id != "total_liter" &&
                                e.id != "total_price" &&
                                e.id != "received_price")
                              dates.add(int.parse(e.id));
                          });
                        });
                        print("________");
                        print("Dates length : ${dates.length}");
                        print("________");

                        double totalMonthLiter = 0.0;

                        for (int i = 0; i < dates.length; i++) {
                          var monthSum = await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("${dates[i]}")
                              .get();

                          print("=================================");
                          print(monthSum.data()!["total morning liter"]);
                          print(monthSum.data()!["total evening liter"]);
                          print("=================================");

                          setState(() {
                            totalMonthLiter = totalMonthLiter +
                                monthSum.data()!["total morning liter"] +
                                monthSum.data()!["total evening liter"];
                          });
                        }

                        print("+++++++++++++");
                        print("total Month Liter :${totalMonthLiter}");
                        print("+++++++++++++");

                        if (literDATA.exists) {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .update({
                            "liter": totalMonthLiter,
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection("customers")
                              .doc(data.docs[0]["number"].toString())
                              .collection("milk_data")
                              .doc("${DateTime.now().year}")
                              .collection("${months[DateTime.now().month - 1]}")
                              .doc("total_liter")
                              .set({
                            "liter": totalMonthLiter,
                          });
                        }
                      }
                    }
                    setState(() {
                      sellMilkController.isAdded.value = true;
                    });

                    Get.back();
                  },
                  child: Obx(
                    ()=> Visibility(
                      visible: sellMilkController.isAdded.value,
                      replacement:  Transform.scale(
                        scale: 0.6,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
                      child: GlobalText(text: "${LocaleString().sell.tr}"),
                    ),
                  )),
              cancel: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: GlobalText(text: "${LocaleString().cancelText.tr}"),
              ),
            );
          } else {
            Get.snackbar(LocaleString().opps.tr, LocaleString().oppsMsg.tr,
                backgroundColor: AppColors.darkBlue,
                colorText: AppColors.white);
          }
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(right: 30, left: 30)),
        child: GlobalText(
          text: LocaleString().addMilkButtonText.tr,
        ));
  }

  cancelButton() {
    return ElevatedButton(
        onPressed: () {
          sellMilkController.liter.value = 0.0;
          sellMilkController.duration.value = "07:00 AM";
          sellMilkController.isMorningSelected.value = true;
          sellMilkController.isEveningSelected.value = false;
          sellMilkController.customerName.value = "";
          sellMilkController.liter.value = 0.5;
          sessionMenu = "morning";
        },
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
                            isEqualTo: FirebaseAuth
                                .instance.currentUser!.phoneNumber
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
                            sellMilkController.customerName.value =
                                value.toString();
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

  timePicker({
    required name,
    required msg,
    required onTap,
    required icon,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Obx(
                        () => GlobalText(
                          text: "${sellMilkController.duration.value}",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Icon(
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
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  literPicker({
    required String name,
    required String msg,
  }) {
    return Padding(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Obx(
                      () => GlobalText(
                        text: sellMilkController.liter.value.toString(),
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          sellMilkController.liter.value += 0.5;
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: AppColors.borderColor,
                          child: Icon(
                            Icons.add,
                            color: AppColors.blue,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          if (sellMilkController.liter.value > 0.5)
                            sellMilkController.liter.value -= 0.5;
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: AppColors.borderColor,
                          child: Icon(
                            Icons.remove,
                            color: AppColors.blue,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
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
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
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
            alignment: Alignment(-0.9, -0.95),
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
                          text: (sessionMenu.toString() == 'morning')
                              ? LocaleString().morningSession.tr
                              : LocaleString().eveningSession.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.borderColor,
                        child: Icon(
                          icon,
                          color: AppColors.blue,
                          size: 20,
                        ),
                      )
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
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          // Callback that sets the selected popup menu item.
          onSelected: (Menu item) {
            setState(() {
              sessionMenu = item.name.toString();
              if (sessionMenu == 'morning') {
                sellMilkController.isMorningSelected.value = true;

                sellMilkController.isEveningSelected.value = false;
                if (sellMilkController.isEveningSelected.value) {
                  sellMilkController.isMorningSelected.value = true;
                }
              } else {
                sellMilkController.isEveningSelected.value = true;

                sellMilkController.isMorningSelected.value = false;
                if (sellMilkController.isMorningSelected.value) {
                  sellMilkController.isEveningSelected.value = true;
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
                              value: sellMilkController.isMorningSelected.value,
                              onChanged: (value) {
                                setState(() {
                                  sessionMenu = Menu.morning.name;
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
                              value: sellMilkController.isEveningSelected.value,
                              onChanged: (value) {
                                setState(() {
                                  sessionMenu = Menu.evening.name;
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
    print("");
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
