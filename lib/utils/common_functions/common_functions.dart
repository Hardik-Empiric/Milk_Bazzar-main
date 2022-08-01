
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';

countryCodePicker(BuildContext context) {
  return Container(

    child: CountryCodePicker(
      dialogBackgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Theme.of(context).backgroundColor,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 17,
      ),
      dialogTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 17,
      ),
      showFlagMain: false,

      searchDecoration: const InputDecoration(
        focusColor: AppColors.blue,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
        ),
        border:OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
        ),
      ),

      searchStyle:TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 17,
      ),

      padding: EdgeInsets.zero,
      showCountryOnly: false,
      onChanged: (val){

      },
      initialSelection: '+91',
      flagWidth: 0,
      showFlagDialog: true,
      showOnlyCountryWhenClosed: false,
      enabled: true,


      showFlag: false,
      favorite: const ['+91', 'IND'],

    ),
  );
}
