import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final CollectionReference users = FirebaseFirestore.instance.collection('users');


  Future<void> signInWithEmailAndPassword ({
    required String email,
    required String pass
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<String> createUser ({
    required String email,
    required String userName,
  }) async {
    final result = await users.where('email',isEqualTo: email).get();
    final res = result.docs.isEmpty;
    late DocumentReference docRef;
    if(res){
       docRef =  await users.add({
      'userName': userName,
      'email' : email,
      'phoneNumber' : '',
      'isPhoneNumberVerified' : false,
      'createdAt' : FieldValue.serverTimestamp()
    });

    return docRef.id;
    }

    return " ";
  }

  Future<String> getUserDocID({required String email}) async {
    final result = await users.where('email',isEqualTo: email).get();
    final res = result.docs.first.id;
    return res;
  }

  Future<void> updateUserName(String userName, String docID) async {
     await users.doc(docID).update({
      "userName" : userName
    });
  }

    Future<void> updatePhoneNumber(String phoneNumber, String docID) async {
     await users.doc(docID).update({
      "phoneNumber" : phoneNumber
    });
  }

  Stream<DocumentSnapshot> getUserDetailsStream(String documentID) {
    final docSnap = users.doc(documentID).snapshots();
    return docSnap;
  }

  

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );


  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

