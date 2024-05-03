import 'package:cloud_firestore/cloud_firestore.dart';

class SlotModel {
  String userID;
  List<dynamic> pickedSlots;

  SlotModel({required this.userID, required this.pickedSlots});

  factory SlotModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic,dynamic>;
    return SlotModel(
      userID: data['userID'] ?? '',
      pickedSlots : data['pickedSlots'] ?? []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'pickedSlots' : pickedSlots
    };
  }

  Future<List<SlotModel>> fetchSlots() async {
    CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('slots');
    QuerySnapshot snapshot = await dataCollection.get();
    List<SlotModel> dataList =
        snapshot.docs.map((doc) => SlotModel.fromFirestore(doc)).toList();
    // Use dataList as needed
    return dataList;
  }

  Future<void> saveSlots(SlotModel data) async {
    CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('slots');
    await dataCollection.doc().set(data.toJson());
  }
}
