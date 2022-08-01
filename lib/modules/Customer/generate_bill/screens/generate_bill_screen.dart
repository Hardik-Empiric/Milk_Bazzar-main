import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../widgets/generate_bill_widget.dart';

class GenerateBillScreen extends StatefulWidget {
  const GenerateBillScreen({Key? key}) : super(key: key);

  @override
  State<GenerateBillScreen> createState() => _GenerateBillScreenState();
}

class _GenerateBillScreenState extends State<GenerateBillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child: Container(
          height: SizeData.height,
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: const [
                Bill(),
                SendBillButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
