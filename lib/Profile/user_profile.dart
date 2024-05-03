import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports_village/Firebase/auth.dart';

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
        appBar: AppBar(),
        body: FutureBuilder(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // final userName = snapshot.data!['userName'];
                  // final email = snapshot.data!['email'];
                  // final phoneNumber = snapshot.data!['phoneNumber'];
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

    Widget rowWithEdit(String inputText, int index,String userName,String phoneNumber) {
      return Row(
        children: [
          Text(inputText),
          if (!inputText.contains("Email"))
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            content: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                  hintText: index == 0
                                      ? userName
                                      : index == 1
                                          ? phoneNumber
                                          : ""),
                            ),
                            title: Text("Edit ${inputText.split(" ")[0]}"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (index == 0) {
                                      Auth().updateUserName(
                                          controller.text, documentID);
                                    } else {
                                      Auth().updatePhoneNumber(
                                          controller.text, documentID);
                                    }
                                    var snackBar = SnackBar(
                            duration:  const Duration(seconds: 3),
                              content: Text(
                                  index == 0 ? "UserName updated successfully" : "PhoneNumber updated successfully"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Confirm")),
                            ],
                          ));
                },
                icon: const Icon(Icons.edit))
        ],
      );
    }

    return StreamBuilder(
        stream: Auth().getUserDetailsStream(documentID),
      builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
                  final userName = snapshot.data!['userName'];
                  final email = snapshot.data!['email'];
                  final phoneNumber = snapshot.data!['phoneNumber'];
            return SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  width: size.width,
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage('resources/images/indoor.jpg'),
                ),
                rowWithEdit("User Name : $userName", 0,userName,phoneNumber),
                rowWithEdit("Email : $email", 2,userName,phoneNumber),
                rowWithEdit("PhoneNumber : $phoneNumber", 1,userName,phoneNumber),
              ],
            ));
          }

          return const CircularProgressIndicator();
        });
  }
}
