import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Profile/login.dart';
import 'package:sports_village/YourBookings/booking_details.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/getx/navigation_controll.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;

class YourBookings extends StatefulWidget {
  const YourBookings({super.key, required this.dateChangeString});

  final String dateChangeString;

  @override
  State<YourBookings> createState() => _YourBookingsState();
}

class _YourBookingsState extends State<YourBookings> {

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder<User?>(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.redlevel2,
              ),
            );
          } else {
            if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: AppColors.whiteLeve1,
                body: GetBuilder<NavigationController>(
                  builder:(context) => FutureBuilder(
                    future:
                        Auth().getUsersBookingList(dateFilter: navController.checkDate.value),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasData) {
                              var dateTimeString = DateTime.now().toLocal().toString().split("-");
                              var date = dateTimeString[2].split(" ")[0];
                              var month = dateTimeString[1];
                              var year = dateTimeString[0];
                          final todaysData = snapshot.data.where((e) => e['date'] == "$date-$month-$year").toList();
                          final otherData = snapshot.data.where((e) => e['date'] != "$date-$month-$year").toList();
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                todaysData.length > 0 ? const Padding(
                                  padding: EdgeInsets.only(left :15.0,top: 10,bottom: 10),
                                  child: Text("Today's Booking", style: AppTextTheme.btext16Bold,),
                                ) : const SizedBox(),
                                todaysData.length > 0 ? ListView.separated(
                                  separatorBuilder: (context, index) => const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Divider(
                                                thickness: .5,
                                              ),
                                            ),
                                            physics: const NeverScrollableScrollPhysics(),
                                  itemCount: todaysData.length, 
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                          final docID = todaysData[index].id;
                                          final date =
                                              todaysData[index]['date'];
                                          final pickedArena =
                                              todaysData[index]['pickedArena'];
                                          final advancePayment = todaysData
                                              [index]['advancePayment'];
                                          final advanceStatus = todaysData
                                              [index]['advanceStatus'];
                                          final pendingPayment = todaysData
                                              [index]['pendingPayment'];
                                          final pendingPaymentStatus =
                                              todaysData[index]
                                                  ['pendingPaymentStatus'];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: ((context) => BookingDetails(userDoc : docID, documentDocDetails: todaysData[index]) )));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 15,
                                                  bottom: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.white,
                                            
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: height * .075,
                                                    width: width * .13,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        color: AppColors.black),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          date.split('-')[2],
                                                          style:
                                                              AppTextTheme.wtext12,
                                                        ),
                                                        Text(
                                                          date.split('-')[0],
                                                          style:
                                                              AppTextTheme.wtext12,
                                                        ),
                                                        Text(
                                                          time_slot_utils.month[
                                                              int.parse(date.split(
                                                                      '-')[1]) -
                                                                  1],
                                                          style:
                                                              AppTextTheme.wtext12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(
                                                          pickedArena == 0
                                                              ? "Indoor Turf"
                                                              : pickedArena ==
                                                                      1
                                                                  ? 'Outdoor Turf'
                                                                  : " Open Ground",
                                                          style: AppTextTheme
                                                              .btext14Bold,
                                                        ),
                                                        const SizedBox(height: 8,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                'Advance Amount : ${advancePayment.toString()}',style: AppTextTheme.btext12),
                                                                advanceStatus ? paid() : unPaid()
                                                          ],
                                                        ),
                                                        const SizedBox(height: 5,),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                'Pending Amount : ${pendingPayment.toString()}', style: AppTextTheme.btext12,),
                                                                pendingPaymentStatus ? paid() : unPaid()
                                                              ],
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  !pendingPaymentStatus
                                                      ? GestureDetector(
                                                          onTap: () async {
                                                            await Auth()
                                                                .payFullAmount(
                                                                    docID);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 12,
                                                                    horizontal:
                                                                        width *
                                                                            .03),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: AppColors.redlevel2
                                                                ),
                                                            child: const Text(
                                                              "Pay Full",
                                                              style: AppTextTheme.wtext14Bold),
                                                            
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          width: width * .15,
                                                        )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                  ) : const SizedBox(),
                                  otherData.length > 0 ? const Padding(
                                  padding: EdgeInsets.only(left :15.0,top: 10,bottom: 10),
                                  child: Text("Other Bookings", style: AppTextTheme.btext16Bold,),
                                ) : const SizedBox(),
                                otherData.length > 0
                                    ? ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Divider(
                                                thickness: .5,
                                              ),
                                            ),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: otherData.length,
                                        itemBuilder: (context, index) {
                                          final docID = otherData[index].id;
                                          final date =
                                              otherData[index]['date'];
                                          final pickedArena =
                                              otherData[index]['pickedArena'];
                                          final advancePayment = otherData[index]['advancePayment'];
                                          final advanceStatus = otherData[index]['advanceStatus'];
                                          final pendingPayment =otherData[index]['pendingPayment'];
                                          final pendingPaymentStatus = otherData[index]
                                                  ['pendingPaymentStatus'];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: ((context) => BookingDetails(userDoc : docID, documentDocDetails: otherData[index]) )));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 15,
                                                  bottom: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.white,
                                            
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    height: height * .075,
                                                    width: width * .13,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        color: AppColors.black),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          date.split('-')[2],
                                                          style:
                                                              AppTextTheme.wtext12,
                                                        ),
                                                        Text(
                                                          date.split('-')[0],
                                                          style:
                                                              AppTextTheme.wtext12,
                                                        ),
                                                        Text(
                                                          time_slot_utils.month[
                                                              int.parse(date.split(
                                                                      '-')[1]) -
                                                                  1],
                                                          style:
                                                              AppTextTheme.wtext12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(
                                                          pickedArena == 0
                                                              ? "Indoor Turf"
                                                              : pickedArena ==
                                                                      1
                                                                  ? 'Outdoor Turf'
                                                                  : " Open Ground",
                                                          style: AppTextTheme
                                                              .btext14Bold,
                                                        ),
                                                        const SizedBox(height: 8,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                'Advance Amount : ${advancePayment.toString()}',style: AppTextTheme.btext12),
                                                                advanceStatus ? paid() : unPaid()
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8,),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                'Pending Amount : ${pendingPayment.toString()}',style: AppTextTheme.btext12),
                                                                pendingPaymentStatus ? paid() : unPaid()
                                                              ],
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  !pendingPaymentStatus
                                                      ? GestureDetector(
                                                          onTap: () async {
                                                            await Auth()
                                                                .payFullAmount(
                                                                    docID);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 12,
                                                                    horizontal:
                                                                        width *
                                                                            .03),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: AppColors.redlevel2
                                                                ),
                                                            child: const Text(
                                                              "Pay Full",
                                                              style: AppTextTheme.wtext14Bold),
                                                            
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          width: width * .15,
                                                        )
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text("No Bookings found"),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("No data"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("No internet connection"),
                        );
                      }
                    }),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                  backgroundColor: AppColors.whiteLeve1,
                  body:  LoginPage()
                    
                  );
            }
          }
        });
  }

  Widget paid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: const Text("✅",style: TextStyle(fontSize: 12),),
    );
  }

  Widget unPaid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: const Text("❌",style: TextStyle(fontSize: 12),),
    );
  }
}
