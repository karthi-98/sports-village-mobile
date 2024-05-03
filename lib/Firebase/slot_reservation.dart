import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_village/Models/slots_model.dart';


class SlotReservation {
  final CollectionReference slots = FirebaseFirestore.instance.collection("slots");

  Future<void> addSlot({required String userID, required String dateSelected, required int arena, required List<int> pickedSlots}) async {
    String pickedArena = arena == 0 ? "arena1" : arena == 1 ? "arena2" : "arena3";  
    slots.doc(dateSelected).collection(pickedArena).add({
      "userId": userID,
      "pickedSlots" : pickedSlots
    });
  }

  Future<List<int>> getSlotDetails({required String date, required int arena}) async {
    String pickedArena = arena == 0 ? "arena1" : arena == 1 ? "arena2" : "arena3"; 
    final QuerySnapshot<Map<String,dynamic>> docsQuery = await slots.doc(date).collection(pickedArena).get();
    final docs = docsQuery.docs.map((docs) => SlotModel.fromFirestore(docs)).toList();
    List<int> bookedSlots = [];
    for(int i = 0; i<docs.length; i++) {
      var pickedSlots = docs[i].pickedSlots;
      for(int i = 0;i<pickedSlots.length;i++){
        bookedSlots.add(pickedSlots[i]);
      }
    }

    return bookedSlots;
    
  }
}