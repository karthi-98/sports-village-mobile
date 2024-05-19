import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_village/Models/slots_model.dart';

class SlotReservation {
  final CollectionReference slots =
      FirebaseFirestore.instance.collection("slots");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  Future<void> addSlot(
      {required String userID,
      required String dateSelected,
      required int arena,
      required List<int> pickedSlots,
      required int advancePayment,
      required bool advanceStatus,
      required int pendingPayment,
      required bool pendingPaymentStatus,
      required int fullAmount}) async {
    String pickedArena = arena == 0
        ? "arena1"
        : arena == 1
            ? "arena2"
            : "arena3";
    await slots
        .doc(dateSelected)
        .collection(pickedArena)
        .add({
          "userId": userID, 
          "pickedSlots": pickedSlots, 
          "createdAt" : DateTime.now().toLocal(),});

    await users.doc(userID).collection("bookedSlots").add({
      "date" : dateSelected,
      "pickedArena" : arena,
      "pickedSlots" : pickedSlots,
      "advancePayment" : advancePayment,
      "advanceStatus" : advanceStatus,
      "pendingPayment" : pendingPayment,
      "pendingPaymentStatus" : pendingPaymentStatus,
      "fullAmount" : fullAmount,
      "createdAt" : DateTime.now().toLocal()
    });
  }

  Future<List<int>> getSlotDetails(
      {required String date, required int arena}) async {
        print(date);
        print(arena.toString());
    String pickedArena = arena == 0
        ? "arena1"
        : arena == 1
            ? "arena2"
            : "arena3";
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
