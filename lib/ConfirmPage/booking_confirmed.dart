
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/getx/slot_controller.dart';
import 'package:sports_village/main.dart';
import 'package:sports_village/utils/colors_util.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;

class BookingConfirmed extends StatelessWidget {
  const BookingConfirmed({super.key,required this.totalAmount});

  final int totalAmount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final slotController = Get.put(SlotController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        spreadRadius: 3,
                        blurRadius: 5)
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: EdgeInsets.only(top: height * .08, bottom: height * .03),
                      alignment: Alignment.center,
                      width: width,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: const Text(
                        "Booking Confirmed",
                        style: AppTextTheme.wtext18Bold,
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text("${slotController.pickedDate.value} - ${slotController.pickedArena.value == 0 ? "Indoor Turf" : slotController.pickedArena.value == 1 ? "Outdoor Turf" : "Open Ground"}",style: AppTextTheme.btext14Bold),
                  SizedBox(
                    height: height * 0.02,
                  ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Divider(color: AppColors.whiteLeve3.withOpacity(.5),),
                   ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child : ListView.builder(
                        padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: slotController.pickedSlots.length,
                            itemBuilder: (context, index) {
                              late String nextIndex;
                              var data = slotController.pickedSlots;
                              if (time_slot_utils.timeSlotUtils.length ==
                                  data[index] + 1) {
                                nextIndex = time_slot_utils.timeSlotUtils[0];
                              } else {
                                nextIndex =
                                    time_slot_utils.timeSlotUtils[data[index] + 1];
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "🏏 ${time_slot_utils.timeSlotUtils[data[index]]}  -  $nextIndex",
                                  style: const TextStyle(fontSize: 14),
                                
                              
                            ));
                            })),),
                  
                   SizedBox(
                    height: height * 0.02,
                  ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Divider(color: AppColors.whiteLeve3.withOpacity(.5),),
                   ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Advance Paid :   ₹ ${totalAmount~/4}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                    SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Pending Payment :   ₹ ${totalAmount - (totalAmount~/4)}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                ],
              ),
            ),
           SizedBox(
                    height: height * 0.04,
                  ),
           GestureDetector(
              onTap: () {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const MyHomePage(title: "Sports Village",)), (Route<dynamic> route) => false);
              },
              child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: width * .1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor('#c41111'),
            boxShadow: [
              BoxShadow(
                  color: Colors.red.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 10)
            ]),
        child: Text(
          "Go to Homepage",
          style: TextStyle(color: HexColor('fef2f2'), fontSize: 14),
        ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
