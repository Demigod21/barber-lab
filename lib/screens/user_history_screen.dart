import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_barber_shop/cloud_firestore/user_ref.dart';
import 'package:custom_barber_shop/model/barber_model.dart';
import 'package:custom_barber_shop/model/booking_model.dart';
import 'package:custom_barber_shop/screens/booking_screen.dart';
import 'package:custom_barber_shop/state/state_management.dart';
import 'package:custom_barber_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'home_screen.dart';

class UserHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserHistoryPage();
}

class UserHistoryPage extends State<UserHistory> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            body: Padding(
                padding: const EdgeInsets.all(12),
                child: displayUserHistory())));
    throw UnimplementedError();
  }

  displayUserHistory() {
    return FutureBuilder(
        future: getUserHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var userBookings = snapshot.data as List<BookingModel>;
            if (userBookings == null || userBookings.length == 0) {
              return Center(
                  child: Text(
                      'Impossibile caricare informazioni sulle prenotazioni'));
            } else {
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var syncTime = snapshot.data as DateTime;

                      return ListView.builder(
                          itemCount: userBookings.length,
                          itemBuilder: (context, index) {
                            var isExpired = DateTime.fromMillisecondsSinceEpoch(
                                    userBookings[index].timeStamp)
                                .isBefore(syncTime);
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                              ),
                              child: Column(children: [
                                Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Data',
                                                  style:
                                                      GoogleFonts.robotoMono(),
                                                ),
                                                Text(
                                                  DateFormat("dd/MM/yy").format(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              userBookings[
                                                                      index]
                                                                  .timeStamp)),
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Orario',
                                                  style:
                                                      GoogleFonts.robotoMono(),
                                                ),
                                                Text(
                                                  TIME_SLOT.elementAt(
                                                      userBookings[index].slot),
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                GestureDetector(
                                  onTap: isExpired
                                      ? null
                                      : () {
                                          cancelBooking(
                                              context, userBookings[index]);
                                        },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: isExpired
                                              ? Colors.grey
                                              : Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22),
                                            bottomRight: Radius.circular(22),
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                                isExpired
                                                    ? 'SCADUTO'
                                                    : 'CANCELLA',
                                                style: GoogleFonts.robotoMono(
                                                    color: Colors.white)),
                                          )
                                        ],
                                      )),
                                )
                              ]),
                            );
                          });
                    }
                  });
            }
          }
        });
  }

  void cancelBooking(BuildContext context, BookingModel bookingModel) {
    Alert(
        context: context,
        type: AlertType.warning,
        title: 'CANCELLA APPUNTAMENTO',
        desc:
            'Premendo su conferma, si desidera a procedere alla cancellazione della prenotazione. Si ignori pure l eventuale future notifica di reminder',
        buttons: [
          DialogButton(
              child: Text('ANNULLA'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          DialogButton(
              child: Text('CANCELLA'),
              onPressed: () {
                deleteFromDatabase(bookingModel);
              }),
        ]).show();
  }

  void deleteFromDatabase(BookingModel bookingModel) {
    final databaseReference = FirebaseFirestore.instance;

    var batch = FirebaseFirestore.instance.batch();

    var barberBookingSlot = databaseReference
        .collection('Barber')
        .doc('LorenzoStaff')
        .collection(
            '${DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp))}')
        .doc(bookingModel.slot.toString());

    var barberBooking = databaseReference
        .collection('Barber')
        .doc('LorenzoStaff')
        .collection('BookingStaff')
        .doc(bookingModel.docId.toString());

    var userBooking = bookingModel.reference;

    var tipoServizio = bookingModel.tipoServizio;
    var uuidAlternativo = bookingModel.uuidLinkedHourBooking;
    var slotAlternativo = bookingModel.slotLinkedHourBooking;
    if (tipoServizio == 'BARBA E CAPELLI') {
      var barberBookingSuccessivo = databaseReference
          .collection('Barber')
          .doc('LorenzoStaff')
          .collection('BookingStaff')
          .doc(uuidAlternativo.toString());

      var userBookingSuccessivo = databaseReference
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser.phoneNumber)
          .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
          .doc(uuidAlternativo);


      var barberBookingSlotSuccessivo = databaseReference
          .collection('Barber')
          .doc('LorenzoStaff')
          .collection(
              '${DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp))}')
          .doc(slotAlternativo.toString());

      batch.delete(barberBookingSuccessivo);
      batch.delete(userBookingSuccessivo);
      batch.delete(barberBookingSlotSuccessivo);

    }

    batch.delete(userBooking);
    batch.delete(barberBooking);
    batch.delete(barberBookingSlot);

    batch.commit().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Prenotazione Cancellata!')));
      context.read(deleteFlagRefresh).state =
          !context.read(deleteFlagRefresh).state;
    });
  }
}
