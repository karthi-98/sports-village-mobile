import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/Bloc/bloc_states.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Firebase/slot_reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_village/Profile/login.dart';
import 'package:sports_village/utils/colors_util.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;

class ConfirmPage extends StatelessWidget {
  final String weekDay;
  const ConfirmPage({super.key, required this.weekDay});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dateBloc = BlocProvider.of<DatePickedBloc>(context);
    final arenaBloc = BlocProvider.of<ArenaBloc>(context);
    final timeSlotBloc = BlocProvider.of<GlobalBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            return _appBarTextContainer('$newDate $weekDay');
          }),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 5))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirm Booking",
                style: GoogleFonts.urbanist(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<GlobalBloc, GlobalStates>(builder: (context, state) {
                var data = state.pickedTimeSlots;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.pickedTimeSlots.length,
                    itemBuilder: (context, index) {
                      late String nextIndex;
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
                          "🏏 ${time_slot_utils.timeSlotUtils[data[index]]}  -  $nextIndex ",
                          style: const TextStyle(fontSize: 17),
                        ),
                      );
                    });
              }),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  addSlot() async {
                    String userID = await Auth()
                        .getUserDocID(email: Auth().currentUser!.email!);
                    await SlotReservation().addSlot(
                        userID: userID,
                        dateSelected: dateBloc.state,
                        arena: arenaBloc.state,
                        pickedSlots: timeSlotBloc.state.pickedTimeSlots);
                  }

                  addSlot();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: width * .3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor('c41111'),
                  ),
                  child: _buttonText("Confirm"),
                ),
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
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _appBarTextContainer(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
    );
  }
}
