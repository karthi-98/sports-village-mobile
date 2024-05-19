import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import "../utils/time_slot_utils.dart" as date_utils;
import 'package:figma_squircle/figma_squircle.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails(
      {super.key, required this.userDoc, required this.documentDocDetails});

  final String userDoc;
  final dynamic documentDocDetails;

  @override
  Widget build(BuildContext context) {
    final pickedArena = documentDocDetails['pickedArena'];
    final pickedSlots = documentDocDetails['pickedSlots'];
    final advancePayment = documentDocDetails['advancePayment'];
    final advanceStatus = documentDocDetails['advanceStatus'];
    final pendingPayment = documentDocDetails['pendingPayment'];
    final pendingPaymentStatus = documentDocDetails['pendingPaymentStatus'];
    final fullAmount = documentDocDetails['fullAmount'];
    final date = documentDocDetails['date'];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.whiteLeve1,
        appBar: AppBar(
          backgroundColor: AppColors.whiteLeve1,
          surfaceTintColor: AppColors.whiteLeve1,
          shadowColor: AppColors.whiteLeve1,
          elevation: 2,
          actions: [
            Text(
              date_utils.arena[pickedArena],
              style: AppTextTheme.btext16Bold,
            ),
            Text(
              " - $date",
              style: AppTextTheme.btext16Bold,
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * .02,
              ),
              const Text(
                "Slots Booked",
                style: AppTextTheme.btext18Bold,
              ),
              SizedBox(
                height: height * .02,
              ),
              Container(
                padding:const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pickedSlots.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15,),
                        alignment: Alignment.center,
                        height: 10,
                        margin: const EdgeInsets.only(left: 5,right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.whiteLeve2),
                        child: Text(date_utils.timeSlotUtils[pickedSlots[index]],style: AppTextTheme.btext14,));
                    }),
              ),
                            SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Full Payment  -  ",
                    style: TextStyle(
                        color: AppColors.whiteLeve4,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    "₹ $fullAmount",
                    style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
                         SizedBox(
                height: height * .03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Advance Payment",
                          style: TextStyle(
                              color: AppColors.whiteLeve4,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: height * .005,
                        ),
                        Text(
                          "₹ $advancePayment",
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      height: height * .05,
                      width: width * .20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: advanceStatus ? Colors.green : AppColors.redlevel2,
                      ),
                      alignment: Alignment.center,
                      child: Text(advanceStatus ? "Paid" : "Pay",style: AppTextTheme.wtext14Bold,),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pending Payment",
                          style: TextStyle(
                              color: AppColors.whiteLeve4,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: height * .005,
                        ),
                        Text(
                          "₹ $pendingPayment",
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      height: height * .05,
                      width: width * .20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: pendingPaymentStatus ? Colors.green : AppColors.redlevel2,
                      ),
                      alignment: Alignment.center,
                      child: Text(pendingPaymentStatus ? "Paid" : "Pay",style: AppTextTheme.wtext14Bold,),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              SizedBox(
                height: height * .02,
              ),
              
              
            ],
          ),
        ));
  }
}
