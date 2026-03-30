import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Future<bool> isUsernameTaken(String username) async {
  //   final normalizedUsername = username.trim();
  //
  //   final result = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('username', isEqualTo: normalizedUsername)
  //       .limit(1)
  //       .get();
  //
  //   //print(result);
  //   return result.docs.isNotEmpty;
  // }

  Future<void> registerUser({
    required String email,
    required String userName,
    required String password,
    required String firstName,
    required String lastName,
    required String addressLine01,
    required String addressLine02,
    required String postcode,
    required String county
  }) async {
    // final userNameProv = userName.trim();
    //
    // final userNameTaken = await isUsernameTaken(userNameProv);
    //
    // if (userNameTaken){
    //   throw FirebaseAuthException(code: 'username-already-in-use', message: 'The Username you have chosen already exists, please choose an alternative');
    // }

    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': userName,
      'addressLine01': addressLine01,
      'addressLine02': addressLine02,
      'postcode': postcode,
      'county': county,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _auth.signOut();
  }
  Future<void> validateUserAuth() async {
    print(_auth.currentUser?.uid);
    print(_auth.currentUser?.email);
  }
  Future<String?> getCurrentUserFirstName() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      return null;
    }
    final firstName = doc.data()?['firstName'] as String?;
    if (firstName == null || firstName.length > 10) {
      return null;
    }
    return firstName;
  }

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }
}

