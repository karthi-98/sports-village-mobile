
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/Bloc/bloc_states.dart';
import 'package:sports_village/main.dart';
import 'package:sports_village/utils/colors_util.dart';
import '../utils/time_slot_utils.dart' as time_slot_utils;

class BookingConfirmed extends StatelessWidget {
  const BookingConfirmed({super.key,required this.totalAmount});

  final int totalAmount;

  @override
  Widget build(BuildContext context) {
    final dateBloc = BlocProvider.of<DatePickedBloc>(context);
    final arenaBloc = BlocProvider.of<ArenaBloc>(context);
    final timeSlotBloc = BlocProvider.of<GlobalBloc>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: height * .05),
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
                        alignment: Alignment.center,
                        height: height * .07,
                        width: width,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Text(
                          "Booking Confirmed",
                          style: GoogleFonts.merriweather(
                              fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    const Text("BookedSlots",style:  TextStyle(fontSize: 16),),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text("${dateBloc.state} - ${arenaBloc.state == 0 ? "Indoor Turf" : arenaBloc.state == 1 ? "Outdoor Turf" : "Open Ground"}",style: const TextStyle(fontSize: 16),),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 15),
              
                      decoration: BoxDecoration(
                          color:Colors.white,
                          // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.15),spreadRadius: 2,blurRadius: 10,offset: const Offset(0,10))
                        ]
                      ),
                      child: SingleChildScrollView(
                        child: BlocBuilder<GlobalBloc, GlobalStates>(builder: (context, state) {
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
                                    "🏏 ${time_slot_utils.timeSlotUtils[data[index]]}  -  $nextIndex",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              });
                        }),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Advance Paid : Rs.${totalAmount~/4}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                      SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Pending Payment : Rs.${totalAmount - (totalAmount~/4)}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
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
            "Book more Slots",
            style: TextStyle(color: HexColor('fef2f2'), fontSize: 14),
          ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
