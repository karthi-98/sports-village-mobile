import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/utils/colors_util.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;

class YourBookings extends StatefulWidget {
  const YourBookings({super.key});

  @override
  State<YourBookings> createState() => _YourBookingsState();
}

class _YourBookingsState extends State<YourBookings> {
  DateTime? dateChange = DateTime.now();
  String dateChangeString = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          "Your Bookings",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
              onPressed: () async {
                dateChange = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                );
                if (dateChange != null) {
                  final year = dateChange.toString().split('-')[0];
                  final month = dateChange.toString().split('-')[1];
                  final date =
                      dateChange.toString().split('-')[2].split(" ")[0];
                  setState(() {
                    dateChangeString = "$date-$month-$year";
                  });
                }
              },
              child: Text(
                dateChangeString.isEmpty ?  "Select Date" : dateChangeString,
                style: AppTextTheme.btext12,
              )),
          const SizedBox(
            width: 10,
          ),
           dateChangeString.isNotEmpty ? ElevatedButton(
              onPressed: () {
                  setState(() {
                    dateChangeString = "";
                  });
                },
              child: Text(
                dateChangeString.isNotEmpty ?  "Clear" : dateChangeString,
                style: AppTextTheme.btext12,
              )): 
          const SizedBox(
            width: 10,
          ),
          const SizedBox(
            width: 10,
          ),

        ],
      ),
      body: FutureBuilder(
        future: Auth().getUsersBookingList(dateFilter: dateChangeString),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    snapshot.data.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              final docID = snapshot.data[index].id;
                              final date = snapshot.data[index]['date'];
                              final pickedArena =
                                  snapshot.data[index]['pickedArena'];
                              final pickedSlots =
                                  snapshot.data[index]['pickedSlots'];
                              final advancePayment =
                                  snapshot.data[index]['advancePayment'];
                              final advanceStatus =
                                  snapshot.data[index]['advanceStatus'];
                              final pendingPayment =
                                  snapshot.data[index]['pendingPayment'];
                              final pendingPaymentStatus =
                                  snapshot.data[index]['pendingPaymentStatus'];
                              final fullAmount =
                                  snapshot.data[index]['fullAmount'];
                              final pickedSlotsWithTime = pickedSlots
                                  .map((e) => time_slot_utils.timeSlotUtils[e])
                                  .toList();
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(width: .5,color: Colors.grey),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(.2),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date : $date'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(pickedArena == 'arena1'
                                        ? "Arena : Indoor Turf"
                                        : pickedArena == 'arena2'
                                            ? 'Arena : Outdoor Turf'
                                            : "Arena : Open Ground"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Slots : ${pickedSlotsWithTime.toString()}'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Full Amount : ${fullAmount.toString()}'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Advance Amount : ${advancePayment.toString()}'),
                                        advanceStatus ? paid() : unPaid()
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Pending Payment : ${pendingPayment.toString()}'),
                                        pendingPaymentStatus ? paid() : unPaid()
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    !pendingPaymentStatus
                                        ? GestureDetector(
                                            onTap: () async {
                                              await Auth().payFullAmount(docID);
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: width * .03),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#c41111'),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.red
                                                            .withOpacity(.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 10)
                                                  ]),
                                              child: Text(
                                                "Pay Full",
                                                style: TextStyle(
                                                    color: HexColor('fef2f2'),
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            })
                        : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const Align(
                            alignment: Alignment.center,
                              child: Text("No Bookings found"),
                            ),
                        ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text("No data"),
            );
          } else {
            return const Center(
              child: Text("No internet connection"),
            );
          }
        }),
      ),
    );
  }

  Widget paid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: const Text("✅ Paid"),
    );
  }

  Widget unPaid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: const Text("❌ Not Paid"),
    );
  }
}
