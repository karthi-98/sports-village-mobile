import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/Bloc/bloc_events.dart';
import 'package:sports_village/ConfirmPage/confirm_page.dart';
import 'package:sports_village/Firebase/slot_reservation.dart';
import 'package:sports_village/constants/others.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/utils/colors_util.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;

class TimeSlotPage extends StatefulWidget {
  final String date;
  final int arena;
  final String weekDay;

  const TimeSlotPage(
      {super.key,
      required this.date,
      required this.arena,
      required this.weekDay});

  @override
  State<TimeSlotPage> createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
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
    final arenaBloc = BlocProvider.of<ArenaBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: AppColors.whiteLeve2,
        surfaceTintColor: Colors.white,
        actions: [
          BlocBuilder<ArenaBloc, int>(
              bloc: arenaBloc,
              builder: (context, arenaBlocc) {
                return _appBarTextContainer(arenaBlocc == 0
                    ? "Indoor Turf"
                    : arenaBlocc == 1
                        ? "Outdoor Turf"
                        : "Open Ground");
              }),
          const SizedBox(
            width: 20,
          ),
          BlocBuilder<DatePickedBloc, String>(builder: (context, newDate) {
            return _appBarTextContainer("$newDate ${widget.weekDay}");
          }),
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
                  color: Colors.red,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<int> bookedSlots = snapshot.data as List<int>;
                return MainSlotTimeWidget(
                    bookedSlots: bookedSlots,
                    weekDay: widget.weekDay,
                    date: widget.date);
              }
              return const Center(
                child: Text("No data"),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            }
          }),
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

class MainSlotTimeWidget extends StatefulWidget {
  const MainSlotTimeWidget(
      {super.key,
      required this.bookedSlots,
      required this.weekDay,
      required this.date});

  final String weekDay;
  final List<int> bookedSlots;
  final String date;

  @override
  State<MainSlotTimeWidget> createState() => _MainSlotTimeWidgetState();
}

class _MainSlotTimeWidgetState extends State<MainSlotTimeWidget> {
  List<int> pickedTimeSlots = [];
  late bool isToday;

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
    int hour = int.parse(DateFormat.H().format(DateTime.now().toLocal())) * 2;
    final int mins = int.parse(DateFormat.m().format(DateTime.now().toLocal()));
    if (mins >= 30) {
      hour = hour + 1;
    }
    isToday =
        DateFormat('dd-MM-yyyy').format(DateTime.now().toLocal()) == widget.date
            ? true
            : false;
    final timeSlotBloc = BlocProvider.of<GlobalBloc>(context);
    final arenaBloc = BlocProvider.of<ArenaBloc>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: pickedTimeSlots.length >=2 ? 1 : 0,
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
              timeSlotBloc.add(PickedTimeSlotsEvents(pickedTimeSlots));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmPage(
                            weekDay: widget.weekDay,
                          )));
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                    if (((hour < 11) || !isToday) && arenaBloc.state != 2)
                      _heading(hoursName[0]),
                    if (((hour < 11) || !isToday) && arenaBloc.state != 2)
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
                    if (((hour < 47) || !isToday) && arenaBloc.state != 2)
                      _heading(hoursName[4]),
                    if (((hour < 47) || !isToday) && arenaBloc.state != 2)
                      _gridViewDisplay(hourseList[4], hour, isToday),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            // AnimatedPositioned(
            //   duration: const Duration(milliseconds: 250),
            //   curve: Curves.easeInOutCubic,
            //   bottom: pickedTimeSlots.length < 2 ? -100 : 50,
            //   left: width / 3,
            //   child: GestureDetector(
            //     onTap: () {
            //       if (FirebaseAuth.instance.currentUser == null) {
            //         var snackBar = const SnackBar(
            //             duration: Duration(seconds: 3),
            //             content: Text('Please go back and login to continue'));
            //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //       } else {
            //         pickedTimeSlots.sort((a, b) => a.compareTo(b));
            //         timeSlotBloc.add(PickedTimeSlotsEvents(pickedTimeSlots));
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => ConfirmPage(
            //                       weekDay: widget.weekDay,
            //                     )));
            //       }
            //     },
            //     child: Container(
            //       padding: EdgeInsets.symmetric(
            //           vertical: 15, horizontal: width * .1),
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: HexColor('#c41111'),
            //           boxShadow: [
            //             BoxShadow(
            //                 color: Colors.red.withOpacity(.2),
            //                 spreadRadius: 2,
            //                 blurRadius: 10)
            //           ]),
            //       child: _buttonText("Continue"),
            //     ),
            //   ),
            // ),
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
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
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
