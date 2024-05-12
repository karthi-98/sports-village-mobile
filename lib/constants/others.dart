import 'package:flutter/material.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';

Widget floatingActionButtonWidget(String text,dynamic onPressed) {
  return FloatingActionButton.extended(
    // icon:  iconHolder16White(FontAwesomeIcons.arrowRight),
    label: Text(text,style: AppTextTheme.wtext14),
    isExtended: true,
    onPressed: onPressed,
    backgroundColor: AppColors.redlevel2
  );
}


