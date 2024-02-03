import 'package:chathive/models/user_model.dart';
import 'package:chathive/utills/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static final instance = AuthRepo();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String?> login(
    String email,
    String password,
  ) async {
    try {
      UserModel? userModel = await isUser(email);

      if (userModel != null) {
        if (userModel.isApproved == true) {
          await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);
 
          LocalStorage.saveString(key: 'role', value: userModel.type);
          LocalStorage.saveString(key: 'email', value: email);
          LocalStorage.saveString(key: 'password', value: password);
        } else if (userModel.isApproved == false) {
          return 'You are not approved by admin';
        }
      } else {
        return 'Not Found';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Invalid password.');
      }
    }
    return null;
  }

  Future createUser(String email, String password, {Function? function}) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        function!();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> isUser(String email) async {
    QuerySnapshot<Map<String, dynamic>> document = await firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (document.docs.isNotEmpty) {
      return UserModel.fromMap(document.docs.first.data());
    } else {
      return null;
    }
  }

  Future<String> isLoggedIn() async {
    return LocalStorage.getString(key: 'role');
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
