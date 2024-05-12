import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
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

  @override
  void initState() {
    super.initState();
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    scrollController = ScrollController(initialScrollOffset: 0.0);
    tempDate = DateFormat('dd-MM-yyyy').format(currentDateTime);
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
    return SizedBox(
      height: height * .17,
      width: width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            horizontalCapsuleListView(),
          ]),
    );
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
          width: 10,
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
              dayIndex = index;
              currentDateTime = currentMonthList[index];
              tempDate = DateFormat("dd-MM-yyyy")
                  .format(DateTime.parse(currentDateTime.toString()));
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
    final dateBloc = BlocProvider.of<DatePickedBloc>(context);
    dateBloc.add(DatePickedChangeDate(date: tempDate));
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: topView());
  }
}
