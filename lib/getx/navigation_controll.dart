import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<String> navTitle = "Sports Village".obs;

  final Rx<String> checkDate = "".obs;

  updateNavigation(int index) {
    selectedIndex.value = index;
    if(index == 0) {
      navTitle.value = "Sports Village";
    }

    if(index == 1) {
      navTitle.value = "Bookings";
    }

    if(index == 2) {
      navTitle.value = "Profile";
    }
  }

  updateDate(String newDate) {
    checkDate.value = newDate;
    update();
  }

}
