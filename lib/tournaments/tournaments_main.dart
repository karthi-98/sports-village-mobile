import 'package:flutter/material.dart';
import 'package:sports_village/Firebase/auth.dart';

class TournamentsMainPage extends StatelessWidget {
  const TournamentsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Tournaments",
        style: TextStyle(fontSize: 18),
      )),
      body: FutureBuilder(
          future: Auth().getTournamentsList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final title = snapshot.data[index]['title'];
                        return Text(title);
                      },
                    ),
                  );
                }else {
                  return const Center(
                  child: Text("No Upcoming Tournaments"),
                );
                }
              } else {
                return const Center(
                  child: Text("No Upcoming Tournaments"),
                );
              }
            } else {
              return const Center(
                child: Text("Server Issue"),
              );
            }
          }),
    );
  }
}
