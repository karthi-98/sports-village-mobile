import 'package:flutter/material.dart';
import 'package:sports_village/constants/themes/colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const btext18 = TextStyle(fontSize: 18, color: AppColors.black,letterSpacing: .8);
  static const btext18Bold = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black,letterSpacing: .8);
  static const wtext18 = TextStyle(fontSize: 18, color: AppColors.whiteLeve2,letterSpacing: .8);
  static const wtext18Bold = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.whiteLeve2,letterSpacing: .8);

  static const btext16 = TextStyle(fontSize: 16, color: AppColors.black);
  static const btext16Bold = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black);
  static const wtext16 = TextStyle(fontSize: 16, color: AppColors.whiteLeve2,letterSpacing: 1);
  static const wtext16Bold = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.whiteLeve2,letterSpacing: 1);

  static const btext14 = TextStyle(
      fontSize: 14, color: AppColors.black,decoration: TextDecoration.none, fontWeight: FontWeight.w500,letterSpacing: .4);
  static const btext14Bold = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black);
  static const wtext14 = TextStyle(fontSize: 14, color: AppColors.whiteLeve2);
  static const wtext14Bold = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.whiteLeve2);

  static const btext12 = TextStyle(
      fontSize: 12, color: AppColors.black,letterSpacing: .8);
  static const btext12Bold = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.black,letterSpacing: .8);
  static const wtext12 = TextStyle(fontSize: 12, color: AppColors.whiteLeve2,letterSpacing: .8);
  static const wtext12Bold = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.whiteLeve2,letterSpacing: .8);
}
