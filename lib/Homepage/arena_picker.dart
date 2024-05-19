import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/constants/widgets.dart';
import 'package:sports_village/getx/slot_controller.dart';
import 'package:sports_village/timeslot/time_slot.dart';

class ArenaPicker extends StatefulWidget {
  const ArenaPicker({super.key});

  @override
  State<ArenaPicker> createState() => _ArenaPickerState();
}

class _ArenaPickerState extends State<ArenaPicker> {
  final slotController = Get.put(SlotController());
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: slotController.pickedArena.value, viewportFraction: .8);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Select your Arena",
            style: AppTextTheme.btext16Bold,
          ),
          SizedBox(
            height: size.height * .03,
          ),
          AspectRatio(
            aspectRatio: 1.8,
            child: PageView.builder(
              onPageChanged: (index) {
                slotController.updateArena(index);
              },
              itemCount: 3,
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              itemBuilder: (context, index) {
                return carouselView(index, size);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
              onTap: () {
                Get.to(()=> TimeSlotPage(
                    date: slotController.pickedDate.value,
                    arena: slotController.pickedArena.value));
              },
              child: buttonContainer("Continue"))
        ],
      ),
    );
  }

  Widget carouselView(int index, Size size) {
    return carouselCard(index, size);
  }

  Widget carouselCard(int index, Size size) {
    final containerImage = [
      "resources/images/indoor.jpg",
      "resources/images/outdoor.jpg",
      "resources/images/open.jpg"
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Obx(
            () => Container(
              height: size.height * .2,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(containerImage[index]),
                      fit: BoxFit.cover)),
              alignment: Alignment.topCenter,
              child: slotController.pickedArena.value == index
                  ? Container(
                      width: size.width,
                      alignment: Alignment.center,
                      height: 30,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        color: AppColors.black,
                      ),
                      child: const Text(
                        "Selected",
                        style: AppTextTheme.wtext14Bold,
                      ))
                  : const SizedBox(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            index == 0
                ? "Indoor Turf"
                : index == 1
                    ? "Outdoor Turf"
                    : "Open Ground",
            style: AppTextTheme.btext14Bold,
          ),
        ],
      ),
    );
  }
}
