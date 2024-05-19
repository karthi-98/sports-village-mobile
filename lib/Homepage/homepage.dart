import 'package:flutter/material.dart';
import 'package:sports_village/Homepage/arena_picker.dart';
import 'package:sports_village/Homepage/date_picker.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/tournaments/tournaments_main.dart';

class HomePage extends StatelessWidget {
  const  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.whiteLeve2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                color: AppColors.whiteLeve1,
                boxShadow: [
                  BoxShadow(color: AppColors.whiteLeve3, spreadRadius: 2,blurRadius: 15)
                ]
              ),
              child: const Column(
                children: [
                  DatePickerWidget(),
                  ArenaPicker(),
                ],
              ),
            ),Container(
              margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Text("Upcoming Tournaments",style: AppTextTheme.btext16Bold,),
                     const SizedBox(height: 20,),
                     SizedBox(
                      height: height * .2,
                      child: const TournamentsMainPage())
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
