import 'package:flutter/material.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';

Widget iconHolder16Black(IconData icon) {
  return Icon(
    icon,
    size: 16,
    color: AppColors.black,
  );
}

Widget iconHolder16White(IconData icon) {
  return Icon(
    icon,
    size: 16,
    color: AppColors.whiteLeve1,
  );
}

Widget iconHolder14Black(IconData icon) {
  return Icon(
    icon,
    size: 14,
    color: AppColors.black,
  );
}

Widget iconHolder14White(IconData icon) {
  return Icon(
    icon,
    size: 14,
    color: AppColors.whiteLeve1,
  );
}

Widget buttonContainer(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: AppColors.redlevel2
    ),
    child: Text(
      text,
      style: AppTextTheme.wtext14,
    ),
  );
}
