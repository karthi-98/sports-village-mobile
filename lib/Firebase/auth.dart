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

  Future<void> createUserWithEmailAndPassword ({
    required String email,
    required String pass
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
    users.add({
      'email' : email,
      'pass' : pass
    });
  }

  Future<String> getUserDocID({required String email}) async {
    final result = await users.where('email',isEqualTo: email).get();
    final res = result.docs.first.id;
    return res;
  }

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

