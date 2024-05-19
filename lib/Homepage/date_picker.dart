import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/getx/slot_controller.dart';
import 'package:sports_village/utils/colors_util.dart';
import "../utils/date_utils.dart" as date_util;
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  double width = 0.0;
  double height = 0.0;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now().toLocal();
  late ScrollController scrollController;
  late String tempDate;
  int dayIndex = 0;

  final slotController = Get.put(SlotController());

  @override
  void initState() {
    super.initState();
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    scrollController = ScrollController(initialScrollOffset: 0.0);
    tempDate = DateFormat('dd-MM-yyyy').format(currentDateTime);
    slotController.updateDate(tempDate);
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Date",
            style: AppTextTheme.btext16Bold,
          ),
          Text(
            date_util.DateUtils.months[currentDateTime.month - 1],
            style: AppTextTheme.btext16Bold,
          ),
        ],
      ),
    );
  }

  Widget topView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // const Text("Sports Village", style: TextStyle(fontSize: 32,fontWeight: FontWeight.w600),),
          // SizedBox(height: height * .02,),
          titleView(),
          horizontalCapsuleListView(),
        ]);
  }

  Widget horizontalCapsuleListView() {
    return SizedBox(
      height: height * .1,
      width: width,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
              tempDate = DateFormat("dd-MM-yyyy")
                  .format(DateTime.parse(currentDateTime.toString()));
              slotController.updateDate(tempDate);
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (currentMonthList[index].day != currentDateTime.day)
                  ? const SizedBox()
                  : Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                          color: AppColors.redlevel2, shape: BoxShape.circle),
                    ),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                decoration: BoxDecoration(
                    color: (currentMonthList[index].day != currentDateTime.day)
                        ? Colors.white
                        : AppColors.redlevel2,
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: [
                    Text(
                      currentMonthList[index].day.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: (currentMonthList[index].day !=
                                  currentDateTime.day)
                              ? Colors.black87
                              : HexColor('fff0f3')),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      date_util.DateUtils
                          .weekdays[currentMonthList[index].weekday - 1],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (currentMonthList[index].day !=
                                  currentDateTime.day)
                              ? Colors.black54
                              : HexColor('fff0f3')),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
        margin:  EdgeInsets.only(bottom: height * .01),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: Colors.white,
        child: topView());
  }
}
