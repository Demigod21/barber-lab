import 'package:barber_lab_sabatini/model/booking_model.dart';
import 'package:barber_lab_sabatini/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_lab_sabatini/state/state_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:developer' as developer;

Future<UserModel> getUserProfiles(BuildContext context, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if (snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data());
    context.read(userInformation).state = userModel;
    return userModel;
  } else {
    return UserModel(); //return empty user
  }
}

Future<UserModel> getUserProfilesLogin(
    BuildContext context, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if (snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data());
    context.read(userInformation).state = userModel;
    return userModel;
  } else {
    return UserModel(); //return empty user
  }
}

Future<List<int>> getTimeSlotLorenzo(String date) async {
  final databaseReference = FirebaseFirestore.instance;

  List<int> result = new List<int>.empty(growable: true);

  //if the selected date is in the collection ferie, we treat it as a day with all timeslots occupied
  var ferieRef = databaseReference.collection('Ferie');
  var doc = await ferieRef.doc(date).get();
  if (doc.exists) {
    for (int i = 0; i < 20; i++) {
      result.add(i);
    }
    return result;
  }

  var bookingRef = databaseReference
      .collection('Barber')
      .doc('LorenzoStaff')
      .collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    developer.log('log 1 ${element}');
    result.add(int.parse(element.id));
    developer.log('log 2 ${element.id}');
    developer.log('log 3 ${result}');
  });
  return result;
}

Future<List<BookingModel>> getUserHistory() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance
      .collection('User')
      .doc(FirebaseAuth.instance.currentUser.phoneNumber)
      .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
      .limit(20);

  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  return listBooking;
}

Future<List<BookingModel>> getBarberHistory() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance
      .collection('Barber')
      .doc('LorenzoStaff')
      .collection('BookingStaff')
      .limit(100);

  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  return listBooking;
}
