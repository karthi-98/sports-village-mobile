import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Homepage/homepage.dart';
import 'package:sports_village/Profile/user_profile.dart';
import 'package:sports_village/YourBookings/your_bookings.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/constants/widgets.dart';
import 'package:sports_village/getx/navigation_controll.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white));
  runApp(const MyMainApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // MultiBlocProvider(
        //     providers: [
        //       BlocProvider(create: (_) => ArenaBloc()),
        //       BlocProvider(create: (_) => DatePickedBloc()),
        //       BlocProvider(create: (_) => GlobalBloc())
        //     ],
        MaterialApp(
      title: 'Sports Village',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: const MyMainApp(),
        );
      },
    );
  }
}

class MyMainApp extends StatelessWidget {
  const MyMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sports Village',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          extendedTextStyle: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold)
        ),
        datePickerTheme: const DatePickerThemeData(
  surfaceTintColor: Colors.white,
),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.redlevel1),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          textTheme: GoogleFonts.manropeTextTheme(),
          useMaterial3: true),
      home: const MyHomePage(title: "Sports Village"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navController = Get.put(NavigationController());
    DateTime? dateChange = DateTime.now();
  String dateChangeString = "";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * .08),
        child: Obx(() => Padding(
                padding: const EdgeInsets.only(left: 10,top: 10),
                child: AppBar(
                    leading: Image.asset("resources/images/sv_logo.png"),
                    backgroundColor: AppColors.whiteLeve1,
                    surfaceTintColor: AppColors.whiteLeve1,
                    title:  
                    Text(
                      navController.selectedIndex.value == 0 ? "Sports Village" : navController.selectedIndex.value == 1 ? "Bookings" : "Profile",
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                    ),
                    actions: navController.selectedIndex.value == 1 && Auth().currentUser != null ? [
                      GestureDetector(
                        onTap:  () async {
                          final DateTime? picked = await showDatePicker(
                            initialDate: DateTime.now(),
                            currentDate: DateTime.now().toLocal(),
                            context: context, 
                            firstDate: DateTime(2023), 
                            lastDate: DateTime(2025)
                            );

                            if(picked!=null) {
                              var dateTimeString = picked.toString().split('-');
                              var date = dateTimeString[2].split(" ")[0];
                              var month = dateTimeString[1];
                              var year = dateTimeString[0];

                              if("$date-$month-$year" != navController.checkDate.value) {
                                navController.updateDate("$date-$month-$year");
                              }


                            }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(navController.checkDate.value.isEmpty ? "Date" : navController.checkDate.value, style: AppTextTheme.wtext14Bold,),
                        
                        ),
                      ),
                      const SizedBox(width: 10,),
                      navController.checkDate.value.isNotEmpty ? GestureDetector(
                        onTap : () {
                          navController.updateDate("");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                            color: AppColors.whiteLeve1,
                            border: Border.all(),
                            borderRadius : BorderRadius.circular(10),
                          ),
                          child: const Text("Clear", style: AppTextTheme.btext14Bold,),
                        ),
                      ) : const SizedBox(),
                      const SizedBox(width: 10,),
                    ] : [],
                  ),
              )
        ),
      ),
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: height * .07,
          child: BottomNavigationBar(
            selectedItemColor: AppColors.redlevel1,
            currentIndex: navController.selectedIndex.value,
            onTap: (value) {
              navController.updateNavigation(value);
            },
            backgroundColor: AppColors.whiteLeve1,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Bookings"),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user, size: 18), label:  "Profile"),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Obx(
              () => navController.selectedIndex.value == 0 ? const HomePage() : navController.selectedIndex.value == 1 ?  YourBookings(dateChangeString: dateChangeString,) : const UserProfile())),
    );
  }
}