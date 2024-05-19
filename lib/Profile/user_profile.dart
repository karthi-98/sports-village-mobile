import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Profile/login.dart';
import 'package:sports_village/constants/themes/colors.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    late String documentID;
    Future<String> getUserDetails() async {
      documentID = await Auth().getUserDocID(email: Auth().currentUser!.email!);
      return documentID;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: Auth().authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  return FutureBuilder(
                      future: getUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.redlevel2,
                            ),
                          );
                        } else {
                          if (snapshot.hasData) {
                            return UserProfileMain(
                              documentID: documentID,
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                          await Auth().signOut();
                        },
                              child: const Center(
                                child: Text("Sorry no data found"),
                              ),
                            );
                          }
                        }
                      });
                } else {
                  return const LoginPage();
                }
              }
            }));
  }
}

class UserProfileMain extends StatelessWidget {
  const UserProfileMain({super.key, required this.documentID});

  final String documentID;

  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    final size = MediaQuery.of(context).size;

    Widget rowWithEdit(
        {required String inputText,
        required int index,
        required String data,
        bool isPhoneNumberVerified = false}) {
      return GestureDetector(
        onTap: () {
          if (index == 0 || index == 2) {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      content: TextField(
                        keyboardType: index == 2
                            ? TextInputType.number
                            : TextInputType.emailAddress,
                        controller:
                            index == 0 ? userController : numberController,
                        decoration: InputDecoration(hintText: data),
                        inputFormatters: index == 2
                            ? [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ]
                            : [],
                      ),
                      title: Text("Edit ${inputText.split(" ")[0]}"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (index == 0) {
                                if (userController.text.isNotEmpty) {
                                  Auth().updateUserName(
                                      userController.text, documentID);
                                  var snackBar = const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          "UserName updated successfully"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pop();
                                } else {
                                  var snackBar = const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 2),
                                      content:
                                          Text("UserName should not be empty"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pop();
                                }
                              }
                              if (index == 2) {
                                if (numberController.text.length == 10) {
                                  Auth().updatePhoneNumber(
                                      numberController.text, documentID);
                                  var snackBar = const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          "Phone Number updated successfully"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  Navigator.of(context).pop();
                                } else {
                                  var snackBar = const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 2),
                                      content: Text("Enter 10 digit number"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            },
                            child: const Text("Confirm")),
                      ],
                    ));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.isEmpty && index == 2 ? "$inputText❗" : inputText,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Row(
              children: [
                Text(data,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(
                  width: 15,
                ),
                if (!inputText.contains("Email"))
                  const Icon(
                    Icons.edit,
                    size: 16,
                  )
              ],
            ),
          ],
        ),
      );
    }

    return StreamBuilder(
        stream: Auth().getUserDetailsStream(documentID),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final userName = snapshot.data!['userName'];
            final email = snapshot.data!['email'];
            final phoneNumber = snapshot.data!['phoneNumber'];
            final isPhoneNumberVerified =
                snapshot.data!['isPhoneNumberVerified'];
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      rowWithEdit(
                          inputText: "User Name ", index: 0, data: userName),
                      const SizedBox(
                        height: 15,
                      ),
                      rowWithEdit(inputText: "Email", index: 1, data: email),
                      const SizedBox(
                        height: 15,
                      ),
                      rowWithEdit(
                          inputText: "PhoneNumber",
                          index: 2,
                          data: phoneNumber,
                          isPhoneNumberVerified: isPhoneNumberVerified),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Auth().signOut();
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: AppColors.redlevel2,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Log out",
                              style: TextStyle(
                                  color: AppColors.redlevel2,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ));
          }

          return const CircularProgressIndicator();
        });
  }
}
