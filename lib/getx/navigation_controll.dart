import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Homepage/date_picker.dart';
import 'package:sports_village/Profile/user_profile.dart';

class NavigationController extends GetxController { 
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const DatePickerWidget(),
    Container(color: Colors.red),
    UserProfile(email: Auth().currentUser!.email!)
  ];

}