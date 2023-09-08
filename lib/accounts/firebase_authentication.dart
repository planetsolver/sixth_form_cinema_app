
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firestore/firestore.dart';
import '../util.dart';

Future<bool> signUpWithEmailAndPassword(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    createOrUpdateUser(const UserDetails(firstName: "firstName", surname: "surname", seats: []));
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      debugPrint('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      debugPrint('The account already exists for that email.');
    }
  } catch (e) {
    debugPrint(e as String?);
  }
  return false;
}

Future<bool> signInWithEmailAndPassword(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      debugPrint('No user found for that email.');
      return signUpWithEmailAndPassword(emailAddress, password);
    } else if (e.code == 'wrong-password') {
      debugPrint('Wrong password provided for that user.');
    }
  }
  return false;
}