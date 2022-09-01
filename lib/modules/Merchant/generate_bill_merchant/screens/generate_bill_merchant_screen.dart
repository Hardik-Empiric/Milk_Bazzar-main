import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milk_bazzar/modules/Merchant/select_customer/controller/select_customer_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../controller/generate_bill_merchant_controller.dart';

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milk_bazzar/utils/common_widget/global_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quiver/time.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

import '../../select_customer/controller/select_customer_controller.dart';

class GenerateBillMerchantScreen extends StatefulWidget {
  const GenerateBillMerchantScreen({Key? key}) : super(key: key);

  @override
  State<GenerateBillMerchantScreen> createState() =>
      _GenerateBillMerchantScreenState();
}

class _GenerateBillMerchantScreenState
    extends State<GenerateBillMerchantScreen> {
  DATA navigatorData = Get.arguments;

  final pdf = pw.Document();
  String customerName = "";
  double totalLiterOfMonth = 0.0;
  double prizePerLiter = 0.0;
  List dates = [];
  List filter = [];
  List finalData = [];
  String finalString = '';
  String finalStringPDF = '';
  double finalTotal = 0.0;
  GenerateBillController generateBillController =
      Get.put(GenerateBillController());

  calculateData() async {
    var totalLiter = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .collection("milk_data")
        .doc("${navigatorData.year}")
        .collection("${navigatorData.month}")
        .doc("total_liter")
        .get();
    totalLiterOfMonth = double.parse("${totalLiter.data()!["liter"]}");


    var d = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .get();

    var ppl = await FirebaseFirestore.instance
        .collection("merchants")
        .doc("${d.data()!["merchant"]}")
        .get();


    prizePerLiter = double.parse("${ppl.data()!["price_per_liter"]}");


    print("Total Liter of Month ${totalLiterOfMonth}");
    print("Prize Per liter ${prizePerLiter}");
  }

  getProfile() async {
    var cusName = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .get();

    setState(() {
      customerName = cusName.data()!["name"];
    });
  }

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

  final List<String> monthItemsInENGLISHCap = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  double PreviousTotalPrice = 0.0;
  double PreviousReceivedPrice = 0.0;
  double PreviousAmountDif = 0.0;


  String showMonth = "";

  getData() async {
    int currentMonthIndex = monthItemsInENGLISH.indexOf(navigatorData.month);

    showMonth = monthItemsInENGLISHCap[currentMonthIndex];

    String previousMonth;
    String pcYear;

    if (currentMonthIndex == 0) {
      previousMonth = monthItemsInENGLISH.last;
      pcYear = "${int.parse(navigatorData.year) - 1}";
    }
    else {
      previousMonth = monthItemsInENGLISH[currentMonthIndex - 1];
      pcYear = navigatorData.year;
    }


    print("previousMonth : $previousMonth");
    print("previousYear : $pcYear");

    var preCheckTotalPrice = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .collection("milk_data")
        .doc("${pcYear}")
        .collection("${previousMonth}").doc("total_price").get();

    var preCheckReceivedPrice = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .collection("milk_data")
        .doc("${pcYear}")
        .collection("${previousMonth}").doc("received_price").get();


    if (preCheckTotalPrice.exists) {
      var data = await FirebaseFirestore.instance
          .collection("customers")
          .doc("${navigatorData.uid}")
          .collection("milk_data")
          .doc("${pcYear}")
          .collection("${previousMonth}").doc("total_price").get();

      PreviousTotalPrice = double.parse(data.data()!["price"].toString());
    }

    if (preCheckReceivedPrice.exists) {
      var data = await FirebaseFirestore.instance
          .collection("customers")
          .doc("${navigatorData.uid}")
          .collection("milk_data")
          .doc("${pcYear}")
          .collection("${previousMonth}").doc("received_price").get();

      PreviousReceivedPrice =
          double.parse(data.data()!["received_price"].toString());
    }

    print("PreviousTotalPrice : $PreviousTotalPrice");
    print("PreviousReceivedPrice : $PreviousReceivedPrice");

    PreviousAmountDif = PreviousTotalPrice - PreviousReceivedPrice;

    print("PreviousAmountDif : ${PreviousAmountDif}");


    int ddday = daysInMonth(int.parse(navigatorData.year),
        monthItemsInENGLISH.indexOf("${navigatorData.month}") + 1);

    var untilMonths = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .collection("milk_data")
        .doc("${navigatorData.year}")
        .collection("${navigatorData.month}");

    var data = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .collection("milk_data")
        .doc("${navigatorData.year}")
        .collection("${navigatorData.month}")
        .get();

    dates.clear();

    data.docs.forEach((e) {

      if (e.id != "total_liter" && e.id != "total_price" &&
          e.id != "received_price") dates.add(int.parse(e.id));

    });

    log(dates.length.toString());


    billDetails2.clear();
    billDetails1.clear();

    var date1 = [];
    var date2 = [];

    date1.clear();
    date2.clear();


    print("dates : $dates");

    dates.forEach((element) {

      if(element<=16)
      {
        date1.add(element);
      }
      else
      {
        date2.add(element);
      }


    });

    print("date1 : $date1");
    print("date2 : $date2");




    /// TODO : main Logic

    setState(() {
      billDetails1.add(BillDetails(date: 'DATE', morning: "MORNING", evening: "EVENING", PPL: 0.0),);
    });

    setState(() {
      billDetails2.add(BillDetails(date: 'DATE', morning: "MORNING", evening: "EVENING", PPL: 0.0),);
    });

    for (int i = 1; i <= 16; i++) {
      setState(() {
        billDetails1.add(BillDetails(date: '$i', morning: "-", evening: "-", PPL: 0.0));
      });
    }

    for (int i = 17; i <= ddday; i++) {
      setState(() {
        billDetails2.add(BillDetails(date: "$i", morning: "-", evening: "-", PPL: 0.0));
      });
    }

    for (int i = ddday; i <= 31; i++) {
      setState(() {
        billDetails2.add(BillDetails(date: "-", morning: "-", evening: "-", PPL: 0.0));
      });
    }

    setState(() {
      generateBillController.isLoading.value = false;
    });


    for(var element in date1)
    {
      print("element : $element");
      var d = await untilMonths.doc("$element").get();
      setState(() {
        billDetails1[element] = BillDetails(
            date: "$element",
            morning: ("${d.data()!["total morning liter"]}" == "0")
                ? "-"
                : "${d.data()!["total morning liter"]}",
            evening: ("${d.data()!["total evening liter"]}" == "0")
                ? "-"
                : "${d.data()!["total evening liter"]}",
            PPL: double.parse("${d.data()!["ppl"]}"));

        print("=======================");
        print(billDetails1[element].date);
        print(billDetails1[element].morning);
        print(billDetails1[element].evening);
        print(billDetails1[element].PPL);
        print("=======================");

      });
    }

    for(var element in date2)
    {
      var d = await untilMonths.doc("${element}").get();
      setState(() {
        billDetails2[element-16] = BillDetails(
            date: "${element}",
            morning: ("${d.data()!["total morning liter"]}" == "0")
                ? "-"
                : "${d.data()!["total morning liter"]}",
            evening: ("${d.data()!["total evening liter"]}" == "0")
                ? "-"
                : "${d.data()!["total evening liter"]}",
            PPL: double.parse("${d.data()!["ppl"]}"));

        print("=======================");
        print(billDetails2[element-16].date);
        print(billDetails2[element-16].morning);
        print(billDetails2[element-16].evening);
        print(billDetails2[element-16].PPL);
        print("=======================");

      });
    }



    // date1.forEach((element) async {
    //   print("element : $element");
    //   var d = await untilMonths.doc("$element").get();
    //   setState(() {
    //     billDetails1[element] = BillDetails(
    //         date: "$element",
    //         morning: ("${d.data()!["total morning liter"]}" == "0")
    //             ? "-"
    //             : "${d.data()!["total morning liter"]}",
    //         evening: ("${d.data()!["total evening liter"]}" == "0")
    //             ? "-"
    //             : "${d.data()!["total evening liter"]}",
    //         PPL: double.parse("${d.data()!["ppl"]}"));
    //
    //     print("=======================");
    //     print(billDetails1[element].date);
    //     print(billDetails1[element].morning);
    //     print(billDetails1[element].evening);
    //     print(billDetails1[element].PPL);
    //     print("=======================");
    //
    //   });
    // });

    // date2.forEach((element) async {
    //   var d = await untilMonths.doc("${element}").get();
    //   setState(() {
    //     billDetails2[element-16] = BillDetails(
    //         date: "${element}",
    //         morning: ("${d.data()!["total morning liter"]}" == "0")
    //             ? "-"
    //             : "${d.data()!["total morning liter"]}",
    //         evening: ("${d.data()!["total evening liter"]}" == "0")
    //             ? "-"
    //             : "${d.data()!["total evening liter"]}",
    //         PPL: double.parse("${d.data()!["ppl"]}"));
    //
    //     print("=======================");
    //     print(billDetails2[element-16].date);
    //     print(billDetails2[element-16].morning);
    //     print(billDetails2[element-16].evening);
    //     print(billDetails2[element-16].PPL);
    //     print("=======================");
    //
    //   });
    // });

    billDetails1.forEach((element) {
      print(element.date);
      print(element.morning);
      print(element.evening);
      print(element.PPL);
    });

    billDetails2.forEach((element) {
      print(element.date);
      print(element.morning);
      print(element.evening);
      print(element.PPL);
    });

    // for (int i = 1; i <= 16; i++) {
    //   var d = await untilMonths.doc("$i").get();
    //
    //
    //   if (dates.contains(i)) {
    //     setState(() {
    //       billDetails1.add(
    //         BillDetails(
    //             date: "$i",
    //             morning: ("${d.data()!["total morning liter"]}" == "0")
    //                 ? "-"
    //                 : "${d.data()!["total morning liter"]}",
    //             evening: ("${d.data()!["total evening liter"]}" == "0")
    //                 ? "-"
    //                 : "${d.data()!["total evening liter"]}",
    //             PPL: double.parse("${d.data()!["ppl"]}")),
    //       );
    //     });
    //   } else {
    //     setState(() {
    //       billDetails1.add(BillDetails(date: "$i", morning: "-", evening: "-", PPL: 0.0));
    //     });
    //   }
    // }
    //
    //
    //
    // for (int i = 17; i <= ddday; i++) {
    //   var d = await untilMonths.doc("$i").get();
    //
    //   if (dates.contains(i)) {
    //     setState(() {
    //       billDetails2.add(
    //         BillDetails(
    //             date: "$i",
    //             morning: ("${d.data()!["total morning liter"]}" == "0")
    //                 ? "-"
    //                 : "${d.data()!["total morning liter"]}",
    //             evening: ("${d.data()!["total evening liter"]}" == "0")
    //                 ? "-"
    //                 : "${d.data()!["total evening liter"]}",
    //             PPL: double.parse("${d.data()!["ppl"]}")),
    //       );
    //     });
    //   } else {
    //     setState(() {
    //       billDetails2
    //           .add(BillDetails(date: "$i", morning: "-", evening: "-", PPL: 0.0));
    //     });
    //   }
    // }



    calculateData();




    List main = [];
    List prise = [];



    billDetails1.forEach((element) {
      if (element.date != "-" && element.date != "DATE") {
        main.add(element);
      }
    });

    billDetails2.forEach((element) {
      if (element.date != "-" && element.date != "DATE") {
        main.add(element);
      }
    });

    print("main:$main");

    print(main[0].date);
    print(main[0].morning);
    print(main[0].evening);
    print(main[0].PPL);

    main.forEach((element) {
      if (element.PPL != 0.0) {
        prise.add(element.PPL);
        print("prise : $prise");
      }
    });


    prise = prise.toSet().toList();

    print("prise : $prise");


    for (int i = 0; i < prise.length; i++) {
      filter.add(await untilMonths.where("ppl", isEqualTo: prise[i]).get());
    }

    double totalPrice = 0.0;
    double totalLiter = 0.0;

    for (int i = 0; i < filter.length; i++) {

      totalPrice = prise[i];
      filter[i].docs.forEach((element) {
        totalLiter = totalLiter +
            double.parse(
                "${element["total morning liter"] +
                    element["total evening liter"]}");
      });

      finalData.add(
        {
          "prise": totalPrice,
          "liter": totalLiter,
        },
      );

      print("finalData : $finalData");

      if (filter.length > 1) {
        totalLiter = 0.0;
      }

    }

    double amount = 0.0;

    finalData.forEach((element) async {
      amount = element["liter"] * element["prise"];


      setState(() {
        finalTotal = finalTotal + amount;
        finalString = finalString +
            "${element["liter"]} L * ₹ ${element["prise"]} = ₹ ${amount}\n";
        finalStringPDF = finalStringPDF +
            "${element["liter"]} L * Rs. ${element["prise"]} = Rs. ${amount}\n";
      });

      print("finalTotal : $finalTotal");
      print("finalString : $finalString");

      setState(() {
        generateBillController.downloadEnabled.value = true;
      });

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

      var check = await FirebaseFirestore.instance
          .collection("customers")
          .doc(navigatorData.uid.toString())
          .collection("milk_data")
          .doc("${navigatorData.year}")
          .collection("${navigatorData.month}")
          .doc("total_price")
          .get();

      if (check.exists) {
        await FirebaseFirestore.instance
            .collection("customers")
            .doc(navigatorData.uid.toString())
            .collection("milk_data")
            .doc("${navigatorData.year}")
            .collection("${navigatorData.month}")
            .doc("total_price")
            .update(
          {
            "price": finalTotal,
          },
        );
      } else {
        await FirebaseFirestore.instance
            .collection("customers")
            .doc(navigatorData.uid.toString())
            .collection("milk_data")
            .doc("${navigatorData.year}")
            .collection("${navigatorData.month}")
            .doc("total_price")
            .set(
          {
            "price": finalTotal + PreviousAmountDif,
          },
        );
      }
    });

  }

  List months = [
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

  var currentYear = DateTime.now().year.toString();
  var currentMonth;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  bool isEng = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    billDetails2.clear();
    billDetails1.clear();
    dates.clear();

    print(billDetails1);
    print(billDetails2);
    print(dates);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    billDetails2.clear();
    billDetails1.clear();
    dates.clear();
    getProfile();
    getData();
    buildPDF();
  }

  @override
  Widget build(BuildContext context) {
    prefs.then((prefs) {
      setState(() {
        isEng = (prefs.getBool("English")) ?? true;
      });
    });

    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child: Container(
          height: SizeData.height,
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: AppColors.darkGrey),
                                color: AppColors.tableColor,
                              ),
                              margin: const EdgeInsets.only(top: 7),
                              height: SizeData.height * 0.04,
                              // width: SizeData.width,
                              alignment: Alignment.center,
                              child: GlobalText(
                                text: customerName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: AppColors.blue),
                                color: Theme.of(context).backgroundColor,
                              ),
                              height: SizeData.height * 0.04,
                              // width: SizeData.width,
                              alignment: Alignment.center,
                              child: GlobalText(
                                text:
                                    "${LocaleString().billOf.tr} ${showMonth} / ${navigatorData.year}",
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            (!generateBillController.isLoading.value)
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(1),
                                                1: FlexColumnWidth(2),
                                                2: FlexColumnWidth(2),
                                              },
                                              border: TableBorder.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  style: BorderStyle.solid,
                                                  width: 1),
                                              children: billDetails1.map((e) {
                                                int index =
                                                    billDetails1.indexOf(e);
                                                return TableRow(
                                                  children: [
                                                    (e.date == "DATE")
                                                        ? tableHeader(e.date)
                                                        : (int.parse(e.date) %
                                                                    2 ==
                                                                1)
                                                            ? whiteDate(e.date)
                                                            : tableColorDate(
                                                                e.date),
                                                    (e.morning == "MORNING")
                                                        ? tableHeader(e.morning)
                                                        : (int.parse(e.date) %
                                                                    2 ==
                                                                1)
                                                            ? whiteDate(
                                                                e.morning)
                                                            : tableColorDate(
                                                                e.morning),
                                                    (e.evening == "EVENING")
                                                        ? tableHeader(e.evening)
                                                        : (int.parse(e.date) %
                                                                    2 ==
                                                                1)
                                                            ? whiteDate(
                                                                e.evening)
                                                            : tableColorDate(
                                                                e.evening),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(1),
                                                1: FlexColumnWidth(2),
                                                2: FlexColumnWidth(2),
                                              },
                                              border: TableBorder.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  style: BorderStyle.solid,
                                                  width: 1),
                                              children: billDetails2.map((e) {
                                                int index =
                                                    billDetails2.indexOf(e);
                                                return (e.date != '-')
                                                    ? TableRow(
                                                        children: [
                                                          (e.date == "DATE")
                                                              ? tableHeader(
                                                                  e.date)
                                                              : (int.parse(e.date) %
                                                                          2 ==
                                                                      1)
                                                                  ? whiteDate(
                                                                      e.date)
                                                                  : tableColorDate(
                                                                      e.date),
                                                          (e.morning ==
                                                                  "MORNING")
                                                              ? tableHeader(
                                                                  e.morning)
                                                              : (int.parse(e.date) %
                                                                          2 ==
                                                                      1)
                                                                  ? whiteDate(
                                                                      e.morning)
                                                                  : tableColorDate(
                                                                      e.morning),
                                                          (e.evening ==
                                                                  "EVENING")
                                                              ? tableHeader(
                                                                  e.evening)
                                                              : (int.parse(e.date) %
                                                                          2 ==
                                                                      1)
                                                                  ? whiteDate(
                                                                      e.evening)
                                                                  : tableColorDate(
                                                                      e.evening),
                                                        ],
                                                      )
                                                    : TableRow(
                                                        children: [
                                                          tableColorDate(
                                                              e.date),
                                                          tableColorDate(
                                                              e.morning),
                                                          tableColorDate(
                                                              e.evening),
                                                        ],
                                                      );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: true,
                                        child: Column(
                                          children: [
                                            commonField(
                                              color:
                                              Theme.of(context).backgroundColor,
                                              textColor:
                                              Theme.of(context).primaryColor,
                                              title: LocaleString().cowMilk.tr,
                                              amount: finalString,
                                            ),
                                            commonField(
                                              color: AppColors.tableColor,
                                              textColor: AppColors.black,
                                              title: LocaleString().totalLiter.tr,
                                              amount: "${totalLiterOfMonth} L",
                                            ),
                                            commonField(
                                              color:
                                              Theme.of(context).backgroundColor,
                                              textColor:
                                              Theme.of(context).primaryColor,
                                              title: LocaleString().pMTA.tr,
                                              amount: "₹${PreviousTotalPrice}",
                                            ),
                                            commonField(
                                              color: AppColors.tableColor,
                                              textColor: AppColors.black,
                                              title: LocaleString().pMRA.tr,
                                              amount: "₹${PreviousReceivedPrice}",
                                            ),
                                            commonField(
                                              color:
                                              Theme.of(context).backgroundColor,
                                              textColor: AppColors.black,
                                              title: LocaleString().total.tr,
                                              amount:
                                              "₹${finalTotal + PreviousAmountDif}",
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    height: SizeData.height * 0.7,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 40, left: 40, top: 30, bottom: 50),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: (generateBillController.downloadEnabled.value)
                                ? AppColors.blue
                                : AppColors.lightBlue,
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                          ),
                          onPressed: () async {
                            if (generateBillController.downloadEnabled.value) {
                              downloadPDF();
                            }
                          },
                          icon: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Image.asset('assets/images/WhatssApp.png',
                                  scale: 15)),
                          label: GlobalText(
                            text: (isEng)
                                ? "${LocaleString().sendTo.tr}$customerName"
                                : "$customerName${LocaleString().sendTo.tr}",
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  downloadPDF() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    final file = File('$tempPath/${customerName}_${showMonth}_${navigatorData.year}.pdf');
    print(file.path);
    await file.writeAsBytes(await pdf.save());

    var number = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${navigatorData.uid}")
        .get();

    shareWhatsapp.shareFile(
      XFile(file.path),
      phone: "+91${number.data()!["number"]}",
    );
  }

  buildPDF() {
    pdf.addPage(
      pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            child: pw.Column(
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 0.5, color: PdfColors.grey900),
                    color: PdfColors.lightBlue50,
                  ),
                  margin: const pw.EdgeInsets.only(top: 7),
                  height: SizeData.height * 0.03,
                  width: SizeData.width,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    customerName,
                    style: pw.TextStyle(),
                  ),
                ),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 0.5, color: PdfColors.grey900),
                    color: PdfColors.white,
                  ),
                  height: SizeData.height * 0.03,
                  width: SizeData.width,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "Bill of : ${showMonth} / ${navigatorData.year}",
                    style: pw.TextStyle(),
                  ),
                ),
                pw.SizedBox(
                  width: SizeData.width,
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Table(
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.FlexColumnWidth(2),
                            2: pw.FlexColumnWidth(2),
                          },
                          border: pw.TableBorder.all(
                              color: PdfColors.black,
                              style: pw.BorderStyle.solid,
                              width: 1),
                          children: billDetails1.map((e) {
                            int index = billDetails1.indexOf(e);
                            return pw.TableRow(
                              children: [
                                (e.date == "DATE")
                                    ? pwTableHeader(e.date)
                                    : (int.parse(e.date) % 2 == 1)
                                        ? pwWhiteDate(e.date)
                                        : pwTableColorDate(e.date),
                                (e.morning == "MORNING")
                                    ? pwTableHeader(e.morning)
                                    : (int.parse(e.date) % 2 == 1)
                                        ? pwWhiteDate(e.morning)
                                        : pwTableColorDate(e.morning),
                                (e.evening == "EVENING")
                                    ? pwTableHeader(e.evening)
                                    : (int.parse(e.date) % 2 == 1)
                                        ? pwWhiteDate(e.evening)
                                        : pwTableColorDate(e.evening),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Table(
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.FlexColumnWidth(2),
                            2: pw.FlexColumnWidth(2),
                          },
                          border: pw.TableBorder.all(
                              color: PdfColors.black,
                              style: pw.BorderStyle.solid,
                              width: 1),
                          children: billDetails2.map((e) {
                            int index = billDetails2.indexOf(e);
                            return (e.date != '-')
                                ? pw.TableRow(
                                    children: [
                                      (e.date == "DATE")
                                          ? pwTableHeader(e.date)
                                          : (int.parse(e.date) % 2 == 1)
                                              ? pwWhiteDate(e.date)
                                              : pwTableColorDate(e.date),
                                      (e.morning == "MORNING")
                                          ? pwTableHeader(e.morning)
                                          : (int.parse(e.date) % 2 == 1)
                                              ? pwWhiteDate(e.morning)
                                              : pwTableColorDate(e.morning),
                                      (e.evening == "EVENING")
                                          ? pwTableHeader(e.evening)
                                          : (int.parse(e.date) % 2 == 1)
                                              ? pwWhiteDate(e.evening)
                                              : pwTableColorDate(e.evening),
                                    ],
                                  )
                                : pw.TableRow(
                                    children: [
                                      pwTableColorDate(e.date),
                                      pwTableColorDate(e.morning),
                                      pwTableColorDate(e.evening),
                                    ],
                                  );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                pwCommonField(
                  color: PdfColors.white,
                  textColor: PdfColors.black,
                  title: LocaleString().cowMilk,
                  amount: finalStringPDF,
                ),
                pwCommonField(
                  color: PdfColors.blue50,
                  textColor: PdfColors.black,
                  title: LocaleString().totalLiter,
                  amount: "$finalTotal L",
                ),
                pwCommonField(
                  color: PdfColors.white,
                  textColor: PdfColors.black,
                  title: LocaleString().pMTA,
                  amount: "Rs. $PreviousTotalPrice",
                ),
                pwCommonField(
                  color: PdfColors.blue50,
                  textColor: PdfColors.black,
                  title: LocaleString().pMRA,
                  amount: "Rs. $PreviousReceivedPrice",
                ),
                pwCommonField(
                  color: PdfColors.white,
                  textColor: PdfColors.black,
                  title: LocaleString().total,
                  amount: "Rs. ${finalTotal + PreviousAmountDif}",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  commonField(
      {required Color color,
      required Color textColor,
      required String title,
      required String amount}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        color: color,
      ),
      // width: SizeData.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: SizeData.width * 0.35,
            child: GlobalText(
                text: "${title}",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: textColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (title == LocaleString().total.tr)
                  ? GlobalText(
                      text: amount,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 18)
                  : GlobalText(
                      text: amount,
                      fontWeight: FontWeight.w500,
                      color: textColor),
              (amount == finalString)
                  ? GlobalText(
                      text: "total : ₹ $finalTotal",
                      fontWeight: FontWeight.w500,
                      color: textColor)
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  header(String h1, h2, h3) {
    return TableRow(children: [
      tableHeader(h1),
      tableHeader(h2),
      tableHeader(h3),
    ]);
  }

  whiteColorRow(
      {required String date1, required String mor1, required String eve1}) {
    return TableRow(children: [
      whiteDate(date1),
      whiteRowElements(mor1),
      whiteRowElements(eve1),
    ]);
  }

  tableColorRow({
    required String date1,
    required String mor1,
    required String eve1,
  }) {
    return TableRow(children: [
      tableColorDate(date1),
      tableColorRowElements(mor1),
      tableColorRowElements(eve1),
    ]);
  }

  tableHeader(String name) {
    return Container(
      color: AppColors.tableColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  whiteDate(String val) {
    return Container(
      color: Theme.of(context).backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  whiteRowElements(String val) {
    return Container(
      color: Theme.of(context).backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  tableColorDate(String val) {
    return Container(
      color: AppColors.tableColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        val,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  tableColorRowElements(String val) {
    return Container(
      color: AppColors.tableColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        val,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  pwCommonField(
      {required PdfColor color,
      required PdfColor textColor,
      required String title,
      required String amount}) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.5),
        color: color,
      ),
      width: SizeData.width,
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "${title}",
            style: pw.TextStyle(fontSize: 13, color: textColor),
          ),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              (title == LocaleString().total)
                  ? pw.Text(
                      amount,
                      style: pw.TextStyle(fontSize: 17, color: textColor),
                    )
                  : pw.Text(
                      amount,
                      style: pw.TextStyle(fontSize: 13, color: textColor),
                    ),
              (amount == finalStringPDF)
                  ? pw.Text(
                      "total : Rs. $finalTotal",
                      style: pw.TextStyle(fontSize: 13, color: textColor),
                    )
                  : pw.Container(),
            ],
          ),
        ],
      ),
    );
  }
}

pwHeader(String h1, h2, h3) {
  return pw.TableRow(children: [
    pwTableHeader(h1),
    pwTableHeader(h2),
    pwTableHeader(h3),
  ]);
}

pwWhiteColorRow(
    {required String date1, required String mor1, required String eve1}) {
  return pw.TableRow(children: [
    pwWhiteDate(date1),
    pwWhiteRowElements(mor1),
    pwWhiteRowElements(eve1),
  ]);
}

pwTableColorRow({
  required String date1,
  required String mor1,
  required String eve1,
}) {
  return TableRow(children: [
    pwTableColorDate(date1),
    pwTableColorRowElements(mor1),
    pwTableColorRowElements(eve1),
  ]);
}

pwTableHeader(String name) {
  return pw.Container(
    color: PdfColors.blue50,
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
    child: pw.Text(name,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        )),
  );
}

pwWhiteDate(String val) {
  return pw.Container(
    color: PdfColors.white,
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
    child: pw.Text(
      val,
      style: pw.TextStyle(
        color: PdfColors.black,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pwWhiteRowElements(String val) {
  return pw.Container(
    color: PdfColors.white,
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
    child: pw.Text(
      val,
      style: pw.TextStyle(
        color: PdfColors.black,
      ),
    ),
  );
}

pwTableColorDate(String val) {
  return pw.Container(
    color: PdfColors.blue50,
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
    child: pw.Text(
      val,
      style: pw.TextStyle(
        color: PdfColors.black,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pwTableColorRowElements(String val) {
  return pw.Container(
    color: PdfColors.blue50,
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
    child: pw.Text(
      val,
    ),
  );
}
