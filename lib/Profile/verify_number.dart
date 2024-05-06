import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_village/utils/colors_util.dart';

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({super.key});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  TextEditingController controller = TextEditingController();

  bool codeSent = false;
  bool sendingCode = false;
  String verificationID = "";
  List<String> otp = ['0', '0', '0', '0', '0', '0'];
  String errorOTP = "";
  String message = "";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(.2),
          title: const Text(
            "Phone Number Verification",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: !codeSent
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter Phone Number",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: height * .08,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  prefix: Container(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: const Text("+91"),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  border: const OutlineInputBorder()),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: height * 0.06,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: HexColor('c41111'),
                                  // side: const BorderSide(width: 1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.red.withOpacity(.2)),
                              onPressed: () async {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: '+91${controller.text}',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException e) {},
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    setState(() {
                                      codeSent = true;
                                      verificationID =verificationId;
                                    });
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Text(message)
                  ],
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 50,
                            height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {
                                  otp[0] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {
                                  otp[1] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {
                                  otp[2] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {
                                  otp[3] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {
                                  otp[4] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {
                                  otp[5] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(errorOTP),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationID,
                                  smsCode: otp.join(''));
                          try {
                            await  FirebaseAuth.instance.signInWithCredential(credential);
                            setState(() {
                              errorOTP = "Verification successfuly";
                            });
                          } catch (e) {
                            setState(() {
                              errorOTP = "Verification failed";
                            });
                          }
                        },
                        child: const Text("Verify Phone Number"))
                  ],
                ),
              ));
  }
}
