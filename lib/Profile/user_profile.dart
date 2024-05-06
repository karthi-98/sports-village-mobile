import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/Profile/verify_number.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    late String documentID;
    Future<String> getUserDetails() async {
      documentID = await Auth().getUserDocID(email: email);
      return documentID;
      // return FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(documentID)
      //     .get();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        appBar: AppBar(
          elevation: 2,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(.2),
          title: const Text(
            "Profile Page",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: FutureBuilder(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return UserProfileMain(
                    documentID: documentID,
                  );
                }

                return const Text("No data");
              } else {
                return const Text("Connection Issue");
              }
            }));
  }
}

class UserProfileMain extends StatelessWidget {
  const UserProfileMain({super.key, required this.documentID});

  final String documentID;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final size = MediaQuery.of(context).size;

    Widget rowWithEdit(
        {required String inputText,
        required int index,
        required String data,
        bool isPhoneNumberVerified = false}) {
      return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    content: TextField(
                      keyboardType: index == 2 ? TextInputType.number : TextInputType.emailAddress,
                      controller: controller,
                      decoration: InputDecoration(hintText: data),
                      inputFormatters: index == 2 ? [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ] : [],
                    ),
                    title: Text("Edit ${inputText.split(" ")[0]}"),
                    actions: [
                      TextButton(

                          onPressed:() {
                            if (controller.text.isNotEmpty) {
                              if (index == 0) { 
                                Auth().updateUserName(
                                    controller.text, documentID);
                                var snackBar = const SnackBar(
                                    showCloseIcon: true,
                                    duration: Duration(seconds: 3),
                                    content:
                                        Text("UserName updated successfully"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.of(context).pop();
                              }
                              if (index == 2 && controller.text.length == 10) {
                                try {
                                  Auth().updatePhoneNumber(
                                      controller.text, documentID);
                                  var snackBar = const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          "Phone Number updated successfully"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  Navigator.of(context).pop();
                                } catch (e) {}
                              }else {
                                 var snackBar = const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          "Enter 10 digit number"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                              }
                            } else {
                              var snackBar = const SnackBar(
                                  showCloseIcon: true,
                                  duration: Duration(seconds: 3),
                                  content:
                                      Text("UserName should not be empty"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Confirm")),
                    ],
                  ));
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.user,
                        size: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "User Details",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 2, color: Colors.grey.withOpacity(.2))),
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
