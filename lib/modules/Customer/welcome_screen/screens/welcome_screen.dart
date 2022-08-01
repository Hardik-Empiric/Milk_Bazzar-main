
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';

import '../../../../utils/app_constants.dart';
import '../widgets/welcome_widget.dart';



class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

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
          const Welcome(),
        ],
      ),
    );
  }
}
