import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports_village/ConfirmPage/confirm_page.dart';
import 'package:sports_village/Firebase/slot_reservation.dart';
import 'package:sports_village/constants/others.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/getx/slot_controller.dart';
import 'package:sports_village/utils/colors_util.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;
import "../constants/themes/text_theme.dart";

class TimeSlotPage extends StatefulWidget {
  final String date;
  final int arena;

  const TimeSlotPage(
      {super.key,
      required this.date,
      required this.arena,});

  @override
  State<TimeSlotPage> createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {

  final slotController = Get.put(SlotController());

  Future<List<dynamic>> getTimeSlotsDataFromFirebase() async {
    List<dynamic> tempList = await SlotReservation()
        .getSlotDetails(date: widget.date, arena: widget.arena);
    return tempList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: AppColors.whiteLeve1,
        surfaceTintColor: Colors.white,
        actions: [
          Text(slotController.pickedArena.value == 0 ? "Indoor Turf" : slotController.pickedArena.value == 1 ? "Outdoor Turf" : "Open Ground",style: AppTextTheme.btext16Bold,),
          const SizedBox(
            width: 20,
          ),
          Text(slotController.pickedDate.value,style: AppTextTheme.btext16Bold,),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: FutureBuilder(
          future: getTimeSlotsDataFromFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.redlevel1,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<int> bookedSlots = snapshot.data as List<int>;
                return MainSlotTimeWidget(
                    bookedSlots: bookedSlots,
                    date: widget.date);
              }
              return const Center(
                child: Text("No data"),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.redlevel1,
              ));
            }
          }),
    );
  }

}

class MainSlotTimeWidget extends StatefulWidget {
  const MainSlotTimeWidget(
      {super.key,
      required this.bookedSlots,
      required this.date});

  final List<int> bookedSlots;
  final String date;

  @override
  State<MainSlotTimeWidget> createState() => _MainSlotTimeWidgetState();
}

class _MainSlotTimeWidgetState extends State<MainSlotTimeWidget> {
  List<int> pickedTimeSlots = [];
  late bool isToday;
  final slotController = Get.put(SlotController());

  List<String> hoursName = [
    "Early Morning",
    "Morning",
    "Afternoon",
    "Evening",
    "Night"
  ];
  List<List<int>> hourseList = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
    [24, 25, 26, 27, 28, 29, 30, 31],
    [32, 33, 34, 35, 36, 37],
    [38, 39, 40, 41, 42, 43, 44, 45, 46, 47]
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    int hour = int.parse(DateFormat.H().format(DateTime.now().toLocal())) * 2;
    final int mins = int.parse(DateFormat.m().format(DateTime.now().toLocal()));
    if (mins >= 30) {
      hour = hour + 1;
    }
    isToday =
        DateFormat('dd-MM-yyyy').format(DateTime.now().toLocal()) == widget.date
            ? true
            : false;
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: pickedTimeSlots.isNotEmpty ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: floatingActionButtonWidget(
          "Continue",
          () {
            if (FirebaseAuth.instance.currentUser == null) {
              var snackBar = const SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text('Please go back and login to continue'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              pickedTimeSlots.sort((a, b) => a.compareTo(b));
              slotController.updateSlots(pickedTimeSlots);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfirmPage()));
            }
          },
        ),
      ),
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 2))
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (((hour < 11) || !isToday) && slotController.pickedArena.value != 2)
                      _heading(hoursName[0]),
                    if (((hour < 11) || !isToday) && slotController.pickedArena.value != 2)
                      _gridViewDisplay(hourseList[0], hour, isToday),
                    if ((hour < 23) || !isToday) _heading(hoursName[1]),
                    if ((hour < 23) || !isToday)
                      _gridViewDisplay(hourseList[1], hour, isToday),
                    if ((hour < 31) || !isToday) _heading(hoursName[2]),
                    if ((hour < 31) || !isToday)
                      _gridViewDisplay(hourseList[2], hour, isToday),
                    if ((hour < 37) || !isToday) _heading(hoursName[3]),
                    if ((hour < 37) || !isToday)
                      _gridViewDisplay(hourseList[3], hour, isToday),
                    if (((hour < 47) || !isToday) && slotController.pickedArena.value != 2)
                      _heading(hoursName[4]),
                    if (((hour < 47) || !isToday) && slotController.pickedArena.value != 2)
                      _gridViewDisplay(hourseList[4], hour, isToday),
                    const SizedBox(
                      height: 10,
                    ),
                    if (((hour > 37) && isToday) && slotController.pickedArena.value == 2) SizedBox(
                      width: width,
                      height: height * .8,
                      child: const Center(child: Text("No Slots available", style: AppTextTheme.btext16Bold,)))
                  ],
                ),
              ),
            ),
          ],
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

  Widget _heading(String heading) {
    return Text(
      heading,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _gridViewDisplay(
      List<int> timeSlotsSegregated, int hour, bool isToday) {
    if (isToday && timeSlotsSegregated.contains(hour)) {
      timeSlotsSegregated.removeRange(0, timeSlotsSegregated.indexOf(hour) + 1);
    }
    return GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 15, bottom: 25),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 6),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: timeSlotsSegregated.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (!widget.bookedSlots.contains(timeSlotsSegregated[index])) {
                  if (pickedTimeSlots.contains(timeSlotsSegregated[index])) {
                    pickedTimeSlots.remove(timeSlotsSegregated[index]);
                  } else {
                    pickedTimeSlots.add(timeSlotsSegregated[index]);
                  }
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.bookedSlots.contains(timeSlotsSegregated[index])
                      ? const Color.fromARGB(255, 245, 245, 245)
                      : pickedTimeSlots.contains(timeSlotsSegregated[index])
                          ? HexColor('#f77272')
                          : Colors.white,
                  border: Border.all(
                      width: .8,
                      color: widget.bookedSlots
                              .contains(timeSlotsSegregated[index])
                          ? const Color.fromARGB(255, 245, 245, 245)
                          : pickedTimeSlots.contains(timeSlotsSegregated[index])
                              ? HexColor('#f77272')
                              : const Color.fromARGB(255, 216, 216, 216)),
                  boxShadow:
                      pickedTimeSlots.contains(timeSlotsSegregated[index])
                          ? [
                              BoxShadow(
                                  color: Colors.red.withOpacity(.2),
                                  spreadRadius: 2,
                                  blurRadius: 10)
                            ]
                          : []),
              child: Text(
                time_slot_utils.timeSlotUtils[timeSlotsSegregated[index]],
                style: TextStyle(
                    color: widget.bookedSlots
                            .contains(timeSlotsSegregated[index])
                        ? const Color.fromARGB(255, 112, 112, 112)
                        : pickedTimeSlots.contains(timeSlotsSegregated[index])
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          );
        });
  }
}
