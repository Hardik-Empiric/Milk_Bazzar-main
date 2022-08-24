import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/modules/Customer/invoice_bill/controller/invoive_controller.dart';
import 'package:milk_bazzar/utils/common_widget/global_text.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quiver/time.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../controller/generate_bill_merchant_controller.dart';

class Bill extends StatefulWidget {

  var data;
  var currentMonth;
  var currentYear;

  Bill({this.data, this.currentMonth, this.currentYear});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  final pdf = pw.Document();

  // bool isLoading = true;

  // YearMonth yearMonth = Get.arguments;

  String customerName = "";
  double totalLiterOfMonth = 0.0;
  double prizePerLiter = 0.0;

  List dates = [];

  GenerateBillController generateBillController =
  Get.put(GenerateBillController());



  calculateData() async {
    var totalLiter = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${widget.data["uid"]}")
        .collection("milk_data")
        .doc("${widget.currentYear}")
        .collection("${widget.currentMonth}").doc("total_liter").get();

    setState(() {
      totalLiterOfMonth = totalLiter.data()!["liter"];
    });

    var d = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${widget.data["uid"]}").get();

    var ppl = await FirebaseFirestore.instance
        .collection("merchants")
        .doc("${d.data()!["merchant"]}").get();

    setState(() {
      prizePerLiter = double.parse("${ppl.data()!["prize_per_liter"]}");
    });

    print("Total Liter of Month ${totalLiterOfMonth}");
    print("Prize Per liter ${prizePerLiter}");
  }

  getProfile() async {
    var cusName = await FirebaseFirestore.instance.collection("customers").doc(
        "${widget.data["uid"]}").get();

    customerName = cusName.data()!["name"];
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

  getData() async {
    int ddday = daysInMonth(int.parse(widget.currentYear),
        monthItemsInENGLISH.indexOf("${widget.currentMonth}") + 1);

    var untilMonths = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${widget.data["uid"]}")
        .collection("milk_data")
        .doc("${widget.currentYear}")
        .collection("${widget.currentMonth}");

    var data = await FirebaseFirestore.instance
        .collection("customers")
        .doc("${widget.data["uid"]}")
        .collection("milk_data")
        .doc("${widget.currentYear}")
        .collection("${widget.currentMonth}")
        .get();

    dates.clear();


    data.docs.forEach((e) {
      setState(() {
        if (e.id != "total_liter")
          dates.add(int.parse(e.id));
      });
    });

    log(dates.length.toString());

    setState(() {
      billDetails2.clear();
      billDetails1.clear();
    });

    billDetails2.add(
      BillDetails(date: 'DATE', morning: "MORNING", evening: "EVENING"),
    );
    billDetails1.add(
      BillDetails(date: 'DATE', morning: "MORNING", evening: "EVENING"),
    );

    for (int i = 1; i <= 16; i++) {
      var d = await untilMonths.doc("$i").get();

      if (dates.contains(i)) {
        billDetails1.add(
          BillDetails(
            date: "$i",
            morning: "${d.data()!["total morning liter"]}",
            evening: ("${d.data()!["total evening liter"]}" == "0")
                ? "-"
                : "${d.data()!["total evening liter"]}",
          ),
        );
      } else {
        billDetails1.add(BillDetails(date: "$i", morning: "-", evening: "-"));
      }
    }


    for (int i = 17; i <= ddday; i++) {
      var d = await untilMonths.doc("$i").get();

      if (dates.contains(i)) {
        billDetails2.add(
          BillDetails(
            date: "$i",
            morning: "${d.data()!["total morning liter"]}",
            evening: ("${d.data()!["total evening liter"]}" == "0")
                ? "-"
                : "${d.data()!["total evening liter"]}",
          ),
        );
      } else {
        billDetails2.add(BillDetails(date: "$i", morning: "-", evening: "-"));
      }
    }

    for (int i = ddday; i <= 31; i++) {
      billDetails2.add(BillDetails(date: "-", morning: "-", evening: "-"));
    }

    calculateData();
    setState(() {
      generateBillController.isLoading.value = false;
    });

    log("+++++++++++++++++++++++++++++++");
    log(billDetails1.length.toString());
    log(billDetails2.length.toString());
    log("+++++++++++++++++++++++++++++++");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    billDetails2.clear();
    billDetails1.clear();
    dates.clear();

    log("+++++++++++++++++++++++++++++++");
    log(billDetails1.length.toString());
    log(billDetails2.length.toString());
    log("+++++++++++++++++++++++++++++++");
  }

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  bool isEng = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefs.then((prefs) {
      isEng = (prefs.getBool("English") ?? false);
    });

    print("${widget.data["uid"]}");
    print("${widget.currentYear}");
    print("${widget.currentMonth}");

    getProfile();
    getData();
    buildPDF();


  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Theme
                  .of(context)
                  .primaryColor),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: AppColors.darkGrey),
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
                    border: Border.all(width: 0.5, color: AppColors.blue),
                    color: Theme
                        .of(context)
                        .backgroundColor,
                  ),
                  height: SizeData.height * 0.04,
                  // width: SizeData.width,
                  alignment: Alignment.center,
                  child: GlobalText(
                    text: "${LocaleString().billOf.tr} ${widget.currentMonth} / ${widget.currentYear}",
                    fontWeight: FontWeight.w500,
                    color: Theme
                        .of(context)
                        .primaryColor,
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                style: BorderStyle.solid,
                                width: 1),
                            children: billDetails1.map((e) {
                              int index = billDetails1.indexOf(e);
                              return TableRow(
                                children: [
                                  (e.date == "DATE")
                                      ? tableHeader(e.date)
                                      : (int.parse(e.date) % 2 == 1)
                                      ? whiteDate(e.date)
                                      : tableColorDate(e.date),
                                  (e.morning == "MORNING")
                                      ? tableHeader(e.morning)
                                      : (int.parse(e.date) % 2 == 1)
                                      ? whiteDate(e.morning)
                                      : tableColorDate(e.morning),
                                  (e.evening == "EVENING")
                                      ? tableHeader(e.evening)
                                      : (int.parse(e.date) % 2 == 1)
                                      ? whiteDate(e.evening)
                                      : tableColorDate(e.evening),
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                style: BorderStyle.solid,
                                width: 1),
                            children: billDetails2.map((e) {
                              int index = billDetails2.indexOf(e);
                              return (e.date != '-')
                                  ? TableRow(
                                children: [
                                  (e.date == "DATE")
                                      ? tableHeader(e.date)
                                      : (int.parse(e.date) % 2 == 1)
                                      ? whiteDate(e.date)
                                      : tableColorDate(e.date),
                                  (e.morning == "MORNING")
                                      ? tableHeader(e.morning)
                                      : (int.parse(e.date) % 2 == 1)
                                      ? whiteDate(e.morning)
                                      : tableColorDate(e.morning),
                                  (e.evening == "EVENING")
                                      ? tableHeader(e.evening)
                                      : (int.parse(e.date) % 2 == 1)
                                      ? whiteDate(e.evening)
                                      : tableColorDate(e.evening),
                                ],
                              )
                                  : TableRow(
                                children: [
                                  tableColorDate(e.date),
                                  tableColorDate(e.morning),
                                  tableColorDate(e.evening),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    commonField(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      textColor: Theme
                          .of(context)
                          .primaryColor,
                      title: LocaleString().cowMilk.tr,
                      amount: "${totalLiterOfMonth} L * ₹${prizePerLiter} = ₹${totalLiterOfMonth *
                          prizePerLiter}",
                    ),
                    commonField(
                      color: AppColors.tableColor,
                      textColor: AppColors.black,
                      title: LocaleString().totalLiter.tr,
                      amount: "${totalLiterOfMonth} L",
                    ),
                    commonField(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      textColor: Theme
                          .of(context)
                          .primaryColor,
                      title: LocaleString().pMonth.tr,
                      amount: "₹${0}",
                    ),
                    commonField(
                      color: AppColors.tableColor,
                      textColor: AppColors.black,
                      title: LocaleString().cMonth.tr,
                      amount: "₹${totalLiterOfMonth * prizePerLiter}",
                    ),
                    commonField(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      textColor: Theme
                          .of(context)
                          .primaryColor,
                      title: LocaleString().received.tr,
                      amount: "₹${0}",
                    ),
                    commonField(
                      color: AppColors.tableColor,
                      textColor: AppColors.black,
                      title: LocaleString().total.tr,
                      amount: "₹${totalLiterOfMonth * prizePerLiter}",
                    ),
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
                primary: (!generateBillController.isLoading.value) ? AppColors.blue : AppColors.lightBlue,
                padding:
                const EdgeInsets.only(
                    right: 15, left: 15, top: 10, bottom: 10),
              ),
              onPressed: () async {

                if(!generateBillController.isLoading.value)
                {
                  downloadPDF();
                }
              },
              icon: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Image.asset(
                      'assets/images/WhatssApp.png', scale: 15)),
              label: GlobalText(
                text: (isEng) ? "${LocaleString().sendTo.tr}$customerName" : "$customerName${LocaleString().sendTo.tr}",
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  downloadPDF() async {

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    final file = File('$tempPath/${DateTime.now()}.pdf');
    print(file.path);
    await file.writeAsBytes(await pdf.save());

    shareWhatsapp.shareFile(
      XFile(file.path),
      phone: "+91${widget.data["number"]}",
    );

  }

  buildPDF() {
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
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
                        border: pw.Border.all(
                            width: 0.5, color: PdfColors.grey900),
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
                        border: pw.Border.all(
                            width: 0.5, color: PdfColors.grey900),
                        color: PdfColors.white,
                      ),
                      height: SizeData.height * 0.03,
                      width: SizeData.width,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "Bill of : ${widget.currentMonth} / ${widget.currentYear}",
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
                      amount: "${totalLiterOfMonth} L * Rs. ${prizePerLiter} = Rs. ${totalLiterOfMonth *
                          prizePerLiter}",
                    ),
                    pwCommonField(
                      color: PdfColors.blue50,
                      textColor: PdfColors.black,
                      title: LocaleString().totalLiter,
                      amount: "${totalLiterOfMonth} L",
                    ),
                    pwCommonField(
                      color: PdfColors.white,
                      textColor: PdfColors.black,
                      title: LocaleString().pMonth,
                      amount: "Rs. 0",
                    ),
                    pwCommonField(
                      color: PdfColors.blue50,
                      textColor: PdfColors.black,
                      title: LocaleString().cMonth,
                      amount: "Rs. ${totalLiterOfMonth * prizePerLiter}",
                    ),
                    pwCommonField(
                      color: PdfColors.white,
                      textColor: PdfColors.black,
                      title: LocaleString().received,
                      amount: "Rs. 0",
                    ),
                    pwCommonField(
                      color: PdfColors.blue50,
                      textColor: PdfColors.black,
                      title: LocaleString().total,
                      amount: "Rs. ${totalLiterOfMonth * prizePerLiter}",
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  commonField({required Color color,
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
            width: SizeData.width * 0.3,
            child: GlobalText(
                text: title,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: textColor),
          ),
          GlobalText(
              text: amount, fontWeight: FontWeight.w500, color: textColor),
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
      color: Theme
          .of(context)
          .backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme
              .of(context)
              .primaryColor,
        ),
      ),
    );
  }

  whiteRowElements(String val) {
    return Container(
      color: Theme
          .of(context)
          .backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme
              .of(context)
              .primaryColor,
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
}

pwCommonField({required PdfColor color,
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
        pw.SizedBox(
          width: SizeData.width * 0.3,
          child: pw.Text(
            title,
            style: pw.TextStyle(fontSize: 13, color: textColor),
          ),
        ),
        pw.Text(
          amount,
          style: pw.TextStyle(fontSize: 13, color: textColor),
        ),
      ],
    ),
  );
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
