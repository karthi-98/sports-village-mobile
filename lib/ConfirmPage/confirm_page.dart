import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_village/ConfirmPage/booking_confirmed.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Firebase/slot_reservation.dart';
import 'package:sports_village/Profile/user_profile.dart';
import 'package:sports_village/constants/others.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/getx/navigation_controll.dart';
import 'package:sports_village/getx/slot_controller.dart';
import 'package:sports_village/main.dart';
import "../constants/themes/text_theme.dart";
import '../utils/time_slot_utils.dart' as time_slot_utils;

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final slotController = Get.put(SlotController());
    final width = MediaQuery.of(context).size.width;
    final fullPay = slotController.pickedSlots.length * 500;
    final advancePay = fullPay ~/ 4;
      final navController = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: floatingActionButtonWidget(
        "Pay Advance of  ₹$advancePay",
        () {
          addSlot() async {
            if (await Auth().isPhoneNumberAdded()) {
              String userID =
                  await Auth().getUserDocID(email: Auth().currentUser!.email!);
              await SlotReservation().addSlot(
                  userID: userID,
                  dateSelected: slotController.pickedDate.value,
                  arena: slotController.pickedArena.value,
                  pickedSlots: slotController.pickedSlots as List<int>,
                  advancePayment:advancePay,
                  advanceStatus: true,
                  pendingPayment: fullPay - advancePay,
                  pendingPaymentStatus: false,
                  fullAmount: fullPay);
                  Get.offAll(() => BookingConfirmed(totalAmount: fullPay,));
            } else {
              var snackBar = const SnackBar(
                  showCloseIcon: true,
                  duration: Duration(seconds: 3),
                  content: Text("Add your phone number to continue"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              navController.updateNavigation(2);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage(title: "Sports village",)));
            }
          }

          addSlot();
        },
      ),
      appBar: AppBar(
        backgroundColor: AppColors.whiteLeve1,
        surfaceTintColor: Colors.white,
        actions: [
          Text(slotController.pickedArena.value == 0
              ? "Indoor Turf"
              : slotController.pickedArena.value == 1
                  ? "Outdoor Turf"
                  : "Open Ground",style: AppTextTheme.btext16Bold,),
          const SizedBox(
            width: 20,
          ),
          Text(slotController.pickedDate.value,style: AppTextTheme.btext16Bold,),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Confirm Booking",
                style: AppTextTheme.btext16Bold,
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: slotController.pickedSlots.length,
                    itemBuilder: (context, index) {
                      late String nextIndex;
                      if (time_slot_utils.timeSlotUtils.length ==
                          slotController.pickedSlots[index] + 1) {
                        nextIndex = time_slot_utils.timeSlotUtils[0];
                      } else {
                        nextIndex =
                            time_slot_utils.timeSlotUtils[slotController.pickedSlots[index] + 1];
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "🏏 ${time_slot_utils.timeSlotUtils[slotController.pickedSlots[index]]}  -  $nextIndex -  ₹ ${time_slot_utils.fees[0][0]}",
                          style: const TextStyle(fontSize: 14),
                        
                      
                        ));
              }),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Text("Advance pay:   ₹ $advancePay", style: AppTextTheme.btext16Bold,),
              const SizedBox(
                height: 15,
              ),
              Text("Total Amount:   ₹ $fullPay", style: AppTextTheme.btext16Bold,),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _appBarTextContainer(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
    );
  }
}
