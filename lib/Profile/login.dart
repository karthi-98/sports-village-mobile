import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sports_village/constants/themes/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         SizedBox(width: size.width,),
          SizedBox(
            height: size.height * .5,
            width: size.width * .6,
            child: SvgPicture.asset("resources/svg/login.svg",fit: BoxFit.contain,)),
          GestureDetector(
              onTap: () async {
                try {
                  UserCredential user = await Auth().signInWithGoogle();
                       // ignore: use_build_context_synchronously
                          if (user.user!.email
                              .toString()
                              .contains("@gmail.com")) {
                            await Auth().createUser(
                                email: user.user!.email.toString(),
                                userName: user.user!.displayName.toString());
                          }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: Container(
                width: size.width * .7,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.redlevel2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColors.redlevel2,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google,color: AppColors.whiteLeve1,size: 16,),
                    SizedBox(width: 15,),
                     Text("Sign in with Google", style: TextStyle(fontSize: 16,color: AppColors.whiteLeve1),),
                  ],
                )))
        ],
      ),
    );
  }
}
