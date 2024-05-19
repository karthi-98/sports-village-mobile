import 'package:flutter/material.dart';
import 'package:sports_village/Firebase/auth.dart';
import 'package:sports_village/tournaments/single_tournament.dart';

class TournamentsMainPage extends StatelessWidget {
  const TournamentsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final title = snapshot.data[index]['title'];
                    final image = snapshot.data[index]['image'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SingleTournament(
                                heroTag: title, title: title, image: image)));
                      },
                      child: SizedBox(
                          height: 200,
                          width: 250,
                          child: Hero(
                            tag: title,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    );
                  },
                );
              } else {
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
        });
  }
}
