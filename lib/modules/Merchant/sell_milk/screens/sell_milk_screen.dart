
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';

import '../../../../utils/app_constants.dart';
import '../widgets/sell_milk_widget.dart';


class SellMilkScreen extends StatefulWidget {
  const SellMilkScreen({Key? key}) : super(key: key);

  @override
  State<SellMilkScreen> createState() => _SellMilkScreenState();
}

class _SellMilkScreenState extends State<SellMilkScreen> {

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
          const SellMilk(),
        ],
      ),
    );
  }
}
