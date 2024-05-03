import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.fromWhere});

  final String fromWhere;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final TextEditingController _controllerNum = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, pass: _controllerPass.text);
          if (widget.fromWhere == "home") {
                        Navigator.pop(context);
                  }
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, pass: _controllerPass.text);
          if (widget.fromWhere == "home") {
                        Navigator.pop(context);
                  }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(
      String title, TextEditingController controller, Icon icon) {
    return TextField(
        controller: controller,
        style: const TextStyle(letterSpacing: 0.1),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            // labelText: title,
            hintText: title,
            floatingLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, letterSpacing: 0.5),
            // labelStyle: const TextStyle(letterSpacing: 0.2),
            border: const UnderlineInputBorder(),
            prefixIcon: icon));
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Error : $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Sign Up'));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register' : 'Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 15),
            //     child: Column(children: [
            //       const SizedBox(
            //         height: 15,
            //       ),
            //       _entryField(
            //           "Email", _controllerEmail, const Icon(Icons.alternate_email)),
            //           const SizedBox(
            //         height: 15,
            //       ),
            //       if(!isLogin) _entryField(
            //           "Phone Number", _controllerNum, const Icon(Icons.numbers)),
            //       if(!isLogin) const SizedBox(
            //         height: 15,
            //       ),
            //       _entryField(
            //           "Password", _controllerPass, const Icon(Icons.password)),
            //     ]
            //     )
                
            //     ),
                
            // _errorMessage(),
            // _submitButton(),
            // _loginOrRegisterButton(),
            ElevatedButton(
                onPressed: () async {
                    try {
                      await Auth().signInWithGoogle();
                       if (widget.fromWhere == "home") {
                        Navigator.pop(context);
                  }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                },
                child: const Text("Google Authentication"))
          ],
        ),
      ),
    );
  }
}
