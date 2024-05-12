import 'package:cloud_firestore/cloud_firestore.dart';

class UsersBookedSlots {
  String date;
  String pickedArena;
  List<int> pickedSlots;
  DateTime createdAt;

  UsersBookedSlots({required this.date, required this.pickedArena, required this.pickedSlots,required this.createdAt});

    factory UsersBookedSlots.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic,dynamic>;
    return UsersBookedSlots(
      date: data['date'] ?? '',
      pickedArena: data['pickedArena'] ?? '',
      pickedSlots : data['pickedSlots'] ?? [],
      createdAt : data['pickedSlots'] ?? DateTime.now(),
    );
  } 

    Map<String, dynamic> toJson() {
    return {
      'date': date,
      'pickedArena' : pickedArena,
      'pickedSlots' : pickedSlots,
      'createdAt' : createdAt
    };
  }
}