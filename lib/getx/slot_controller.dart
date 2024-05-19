import 'package:get/get.dart';

class SlotController extends GetxController {
  final Rx<String> pickedDate = "".obs;
  final Rx<int> pickedArena = 1.obs;
  final RxList<int> pickedSlots = <int>[].obs;

  updateDate(String newDate) {
    pickedDate.value = newDate;
  }

  updateArena(int newArena) {
    pickedArena.value = newArena;
  }

  updateSlots(List<int> newSlot) {
    pickedSlots.value = newSlot;
  }
}