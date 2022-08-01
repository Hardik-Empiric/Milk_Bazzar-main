
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';

import '../../../../utils/app_constants.dart';
import '../widgets/invoice_widget.dart';


class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  @override
  Widget build(BuildContext context) {
    SizeData(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// BackLayer
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.blue,
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ],
          ),

          /// FrontLayer
          const Invoice(),
        ],
      ),
    );
  }
}
