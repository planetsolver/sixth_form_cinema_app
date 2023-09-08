
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sixth_form_cinema_app/util.dart';

Future<List<Seat>> getSeatsInOrder(int numRow, int numCol) async {
  List<Seat> unorderedSeats = [];
  List<Seat> seats = [];

  try {
    CollectionReference seatsCollectionReference = FirebaseFirestore.instance.collection("seats");

    QuerySnapshot querySnapshot = await seatsCollectionReference.get();

    for (QueryDocumentSnapshot seatDocument in querySnapshot.docs) {
      Map<String, dynamic> seatData = seatDocument.data() as Map<String, dynamic>;

      unorderedSeats.add(Seat(row: seatData["row"], col: seatData["col"], id: seatDocument.id, ownedById: seatData["ownedById"]));
    }

  } catch (e) {
    debugPrint("Error creating event : $e");
  }

  for (int row = 0; row < numRow; row++) {
    for (int col = 0; col < numCol; col++) {
      bool foundSeat = false;
      for (Seat seat in unorderedSeats) {
        if ((seat.row == row) && (seat.col == col)) {
          foundSeat = true;
          seats.add(seat);
        }
      }
      if (!foundSeat) {
        seats.add(Seat(row: row, col: col, id: null, ownedById: null));
      }
    }
  }

  return seats;
}

Future<bool> createSeat(Seat seat) async {
  try {
    CollectionReference seatsCollectionReference = FirebaseFirestore.instance.collection("seats");

    DocumentReference seatDocumentReference = seatsCollectionReference.doc(seat.id);

    seatDocumentReference.set({
      "row": seat.row,
      "col": seat.col,
      "ownedById": FirebaseAuth.instance.currentUser?.uid,
    });
    return true;
  } catch (e) {
    debugPrint("Error creating event : $e");
  }
  return false;
}

Future<void> createOrUpdateUser(UserDetails user) async{

  List<String> seatIds = [];

  for (Seat seat in user.seats) {
    seatIds.add(seat.id!);
  }

  try {
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection("users");

    DocumentReference userDocumentReference = usersCollectionReference.doc(FirebaseAuth.instance.currentUser!.uid);
    userDocumentReference.set({
      "firstname": user.firstName,
      "surname": user.surname,
      "seats": seatIds,
    });
  } catch (e) {
    debugPrint("Error creating event : $e");
  }
}