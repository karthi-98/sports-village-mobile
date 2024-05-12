import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/Bloc/bloc_states.dart';
import 'package:sports_village/ConfirmPage/booking_confirmed.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Firebase/slot_reservation.dart';
import 'package:sports_village/Profile/user_profile.dart';
import 'package:sports_village/constants/others.dart';
import 'package:sports_village/constants/themes/colors.dart';
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
    final advancePay = timeSlotBloc.state.pickedTimeSlots.length * 500 ~/ 4;
    final fullPay = timeSlotBloc.state.pickedTimeSlots.length * 500;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: floatingActionButtonWidget(
        "Pay Advance of Rs.$advancePay",
        () {
          addSlot() async {
            if (await Auth().isPhoneNumberAdded()) {
              String userID =
                  await Auth().getUserDocID(email: Auth().currentUser!.email!);
              await SlotReservation().addSlot(
                  userID: userID,
                  dateSelected: dateBloc.state,
                  arena: arenaBloc.state,
                  pickedSlots: timeSlotBloc.state.pickedTimeSlots,
                  advancePayment:
                      ((timeSlotBloc.state.pickedTimeSlots.length * 500) ~/ 4),
                  advanceStatus: true,
                  pendingPayment: (timeSlotBloc.state.pickedTimeSlots.length *
                          500) -
                      ((timeSlotBloc.state.pickedTimeSlots.length * 500) ~/ 4),
                  pendingPaymentStatus: false,
                  fullAmount:
                      (timeSlotBloc.state.pickedTimeSlots.length * 500));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => BookingConfirmed(
                            totalAmount:
                                timeSlotBloc.state.pickedTimeSlots.length * 500,
                          )),
                  (Route<dynamic> route) => false);
            } else {
              var snackBar = const SnackBar(
                  showCloseIcon: true,
                  duration: Duration(seconds: 3),
                  content: Text("Add your phone number to continue"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(email: Auth().currentUser!.email!)));
            }
          }

          addSlot();
        },
      ),
      appBar: AppBar(
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
            return _appBarTextContainer('$newDate $weekDay');
          }),
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
              Text(
                "Confirm Booking",
                style: GoogleFonts.urbanist(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<GlobalBloc, GlobalStates>(builder: (context, state) {
                var data = state.pickedTimeSlots;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
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
                          "🏏 ${time_slot_utils.timeSlotUtils[data[index]]}  -  $nextIndex -  Rs.${time_slot_utils.fees[0][0]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    });
              }),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<GlobalBloc, GlobalStates>(builder: (context, state) {
                var totalAmount = state.pickedTimeSlots.length * 500;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount : Rs.$totalAmount',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Advance Amount to pay: Rs.${totalAmount ~/ 4}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              }),
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
