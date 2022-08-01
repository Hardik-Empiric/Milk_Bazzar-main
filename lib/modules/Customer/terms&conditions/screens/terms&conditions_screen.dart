
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../widgets/terms&conditions_widget.dart';


class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {

  @override
  Widget build(BuildContext context) {
    SizeData(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
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
              color:  Theme.of(context).backgroundColor,
              child: const TermsConditions(),
            ),
          ),
        ],
      ),
    );
  }
}
