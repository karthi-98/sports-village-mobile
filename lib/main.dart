import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sports_village/Bloc/bloc_data.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Homepage/date_picker.dart';
import 'package:sports_village/Profile/user_profile.dart';
import 'package:sports_village/YourBookings/your_bookings.dart';
import 'package:sports_village/constants/others.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/constants/widgets.dart';
import 'package:sports_village/tournaments/tournaments_main.dart';
import 'package:sports_village/utils/colors_util.dart';
import 'package:sports_village/timeslot/time_slot.dart';
import "utils/date_utils.dart" as date_util;
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  await Future.delayed(const Duration(seconds: 3))
      .then((value) => FlutterNativeSplash.remove());
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
          title: 'Sports Village',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: const MyMainApp(),
            );
          },
        ));
  }
}

class MyMainApp extends StatelessWidget {
  const MyMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Village',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          textTheme: GoogleFonts.latoTextTheme(),
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: .8);
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    scrollController = ScrollController(initialScrollOffset: 0.0);
    tempDate = DateFormat('dd-MM-yyyy').format(currentDateTime);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _loginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconHolder14Black(FontAwesomeIcons.google),
          const SizedBox(
            width: 5,
          ),
          const Text(
            "Sign in",
            style: AppTextTheme.btext16,
          ),
        ],
      ),
    );
  }

  final drawerStyle = OutlinedButton.styleFrom(
      side: const BorderSide(width: 0, color: Colors.transparent),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      foregroundColor: Colors.black87);

  Widget drawerPlaceHolder(String title, Icon icon) {
    return Container(
      width: width,
      height: height * 0.06,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: width * 0.01),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 1,
          ),
          Text(
            title,
            style: AppTextTheme.btext14,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final arenaBloc = BlocProvider.of<ArenaBloc>(context);
    arenaBloc.add(ArenaChange(arenaValue: _currentPage));
    final dateBloc = BlocProvider.of<DatePickedBloc>(context);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: floatingActionButtonWidget(
              "Continue",
              () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TimeSlotPage(
                        date: dateBloc.state,
                        arena: arenaBloc.state,
                        weekDay: date_util.DateUtils.weekdays[
                            currentMonthList[dayIndex].weekday - 1])));
              },
            ),
            backgroundColor: AppColors.whiteLeve1,
            drawer: Drawer(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        if (snapshot.hasData)
                          OutlinedButton(
                              style: drawerStyle,
                              onPressed: () {
                                if (Auth().currentUser!.email!.isNotEmpty) {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                            email: Auth().currentUser!.email!,
                                          )));
                                }
                              },
                              child: drawerPlaceHolder(
                                  "Profile",
                                  const Icon(
                                    FontAwesomeIcons.user,
                                    color: AppColors.redlevel2,
                                    size: 18,
                                  ))),
                        if (snapshot.hasData)
                          OutlinedButton(
                              style: drawerStyle,
                              onPressed: () {
                                if (Auth().currentUser!.email!.isNotEmpty) {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const YourBookings()));
                                }
                              },
                              child: drawerPlaceHolder(
                                  "Your Bookings",
                                  const Icon(
                                    FontAwesomeIcons.calendar,
                                    color: AppColors.redlevel2,
                                    size: 18,
                                  ))),
                        OutlinedButton(
                            style: drawerStyle,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const TournamentsMainPage()));
                            },
                            child: drawerPlaceHolder(
                                "Upcoming Tournaments",
                                const Icon(
                                  FontAwesomeIcons.medal,
                                  color: AppColors.redlevel2,
                                  size: 18,
                                ))),
                      ],
                    ),
                    if (snapshot.hasData)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 0, color: Colors.grey.withOpacity(.8)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            foregroundColor: Colors.red),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Auth().signOut();
                        },
                        child: drawerPlaceHolder(
                            "Logout",
                            const Icon(
                              FontAwesomeIcons.rightFromBracket,
                              size: 16,
                            )),
                      ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.whiteLeve2,
                // elevation: 1,
                shadowColor: Colors.black.withOpacity(.4),
                surfaceTintColor: Colors.white,
                centerTitle: false,
                toolbarHeight: 70,
                title: !snapshot.hasData
                    ? GestureDetector(
                        onTap: () async {
                          UserCredential user = await Auth().signInWithGoogle();
                          // ignore: use_build_context_synchronously
                          // Navigator.pop(context);
                          if (user.user!.email
                              .toString()
                              .contains("@gmail.com")) {
                            await Auth().createUser(
                                email: user.user!.email.toString(),
                                userName: user.user!.displayName.toString());
                          }
                        },
                        child: _loginButton())
                    : const Text(
                        "Sports Village",
                        style: AppTextTheme.btext16Bold,
                      ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Builder(builder: (context) {
                    return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.bars,
                          size: 18,
                        ));
                  }),
                ),
                actions: [
                  Row(
                    children: [
                      Image.asset(
                        "resources/images/sv_logo.png",
                        height: 80,
                        width: 80,
                      ),
                    ],
                  ),
                ]),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const DatePickerWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Slide to select ground",
                        style: AppTextTheme.btext16Bold,
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
