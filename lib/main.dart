import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Profile/login.dart';
import 'package:sports_village/Profile/user_profile.dart';
import 'package:sports_village/utils/colors_util.dart';
import 'package:sports_village/timeslot/time_slot.dart';
import 'package:flutter_animate/flutter_animate.dart';
import "utils/date_utils.dart" as date_util;
import 'package:flutter_svg/flutter_svg.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ArenaBloc()),
          BlocProvider(create: (_) => DatePickedBloc()),
          BlocProvider(create: (_) => GlobalBloc())
        ],
        child: MaterialApp(
          // builder: (context,child) {
          //   return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
          //     child: const MyHomePage(title: "Sports Village"),
          //   );
          // },
          title: 'Sports Village',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            }),
            textTheme: GoogleFonts.latoTextTheme(),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: "Sports Village"),
          // home: StreamBuilder<User?>(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasError) {
          //       return Text(snapshot.error.toString());
          //     }
          //     if (snapshot.hasData) {
          //       return const MyHomePage(title: "Sports Village");
          //     }
          //     return const LoginPage();
          //   },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> _fadeInOutAnimation;

  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now().toLocal();
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  late String tempDate;
  int arena = 1;

  late PageController _pageController;
  int _currentPage = 1;
  int dayIndex = 0;


  @override
  void initState() {
    // _animationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: .8);
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    // currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    // currentMonthList = currentMonthList.toSet().toList();
    scrollController = ScrollController(initialScrollOffset: 0.0);
    tempDate = DateFormat('dd-MM-yyyy').format(currentDateTime);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Date",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Animate(
            effects: const [FadeEffect(), FlipEffect()],
            child: Text(
              date_util.DateUtils.months[currentDateTime.month - 1],
              // +' ' +
              //     currentDateTime.year.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget topView() {
    return SizedBox(
      height: 150,
      width: width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
          ]),
    );
  }

  Widget hrizontalCapsuleListView() {
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
          width: 5,
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // (currentMonthList[index].day != currentDateTime.day)
                //     ? const SizedBox()
                //     : Container(
                //         width: 5,
                //         height: 5,
                //         decoration: BoxDecoration(
                //             color: HexColor('a23c33'), shape: BoxShape.circle),
                //       ),
                // const SizedBox(
                //   height: 8,
                // ),
                Container(
                  width: 45,
                  height: 65,
                  decoration: BoxDecoration(
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? Colors.white
                              : HexColor('a23c33'),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 11,
                        ),
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
                          height: 5,
                        ),
                        Text(
                          date_util.DateUtils
                              .weekdays[currentMonthList[index].weekday - 1],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: (currentMonthList[index].day !=
                                      currentDateTime.day)
                                  ? Colors.black87
                                  : HexColor('fff0f3')),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _loginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.black87, borderRadius: BorderRadius.circular(10)),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final arenaBloc = BlocProvider.of<ArenaBloc>(context);
    final dateBloc = BlocProvider.of<DatePickedBloc>(context);
    dateBloc.add(DatePickedChangeDate(date: tempDate));
    arenaBloc.add(ArenaChange(arenaValue: _currentPage));
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            drawer: Drawer(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              child: Center(
                child: SafeArea(
                  child: Column(
                    children: [
                      ElevatedButton(onPressed: () {
                        if(Auth().currentUser!.email!.isNotEmpty) {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  UserProfile(email: Auth().currentUser!.email!,)));
                        }
                      }, child: const Text("Profile Page")),
                      IconButton(
                          onPressed: () async {
                        Navigator.pop(context);
                            await Auth().signOut();
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              // elevation: 1,
              shadowColor: Colors.black.withOpacity(.4),
              surfaceTintColor: Colors.white,
              centerTitle: false,
              toolbarHeight: 90,
              title: Image.asset(
                "resources/images/sv_logo.png",
                height: 80,
                width: 80,
              ),
              actions: snapshot.hasData
                  ? [
                      Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Hi, ',
                                style: GoogleFonts.kaushanScript(fontSize: 22),
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('users').where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if(snapshot.hasData) {
                                    return Text(
                                    snapshot.data.docs[0]['userName'],
                                    style: GoogleFonts.kaushanScript(
                                        fontSize: 22, fontWeight: FontWeight.bold),
                                  );
                                  }
                                  return const Text("No name");
                                }
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SvgPicture.asset(
                                'resources/svg/profile.svg',
                                width: 40,
                                height: 40,
                              )
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 15,
                      ),
                    ]
                  : [
                      GestureDetector(
                          onTap: () async {
                            UserCredential user =
                                await Auth().signInWithGoogle();
                            if (user.user!.email
                                .toString()
                                .contains("@gmail.com")) {
                              await Auth().createUser(email: user.user!.email.toString(), userName: user.user!.displayName.toString());
                            } 
                          },
                          child: _loginButton()),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.25),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: const Offset(0, 5))
                          ]),
                      child: topView(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Slide to select ground",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AspectRatio(
                        aspectRatio: 1.8,
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: 3,
                          physics: const ClampingScrollPhysics(),
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            return carouselView(index, size);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TimeSlotPage(
                                date: dateBloc.state,
                                arena: arenaBloc.state,
                                weekDay: date_util.DateUtils.weekdays[
                                    currentMonthList[dayIndex].weekday - 1])));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: width * .2),
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
                          "Continue",
                          style: TextStyle(
                              color: HexColor('fef2f2'), fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
          Container(
            height: size.height * .2,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: AssetImage(containerImage[index]),
                    fit: BoxFit.cover)),
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
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HexColor('3c1613')),
          )
        ],
      ),
    );
  }

  Widget _cardContainer(String image, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
        shadowColor: Theme.of(context).colorScheme.shadow,
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          height: size.height * .1,
          child: Text(image.split("/").last.split(".").first[0].toUpperCase() +
              image
                  .split("/")
                  .last
                  .split(".")
                  .first
                  .substring(1, image.split("/").last.split(".").first.length)),
        )
        // ),
        );
  }
}
