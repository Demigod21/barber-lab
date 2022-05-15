import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_lab_sabatini/cloud_firestore/user_ref.dart';
import 'package:barber_lab_sabatini/model/booking_model.dart';
import 'package:barber_lab_sabatini/state/state_management.dart';
import 'package:barber_lab_sabatini/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StaffHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StaffHistoryPage();
}

class StaffHistoryPage extends State<StaffHistory> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            body: Padding(
                padding: const EdgeInsets.all(12),
                child: displayStaffHistory())));
    throw UnimplementedError();
  }

  displayStaffHistory() {
    return FutureBuilder(
        future: getBarberHistory(),
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
                                                  style: GoogleFonts.raleway(),
                                                ),
                                                Text(
                                                  DateFormat("dd/MM/yy").format(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              userBookings[
                                                                      index]
                                                                  .timeStamp)),
                                                  style: GoogleFonts.raleway(
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
                                                  style: GoogleFonts.raleway(),
                                                ),
                                                Text(
                                                  TIME_SLOT.elementAt(
                                                      userBookings[index].slot),
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Note',
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                Text(
                                                  userBookings
                                                      .elementAt(index)
                                                      .note,
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Nome',
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                Text(
                                                  userBookings
                                                      .elementAt(index)
                                                      .customerName,
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Servizio scelto',
                                                  style: GoogleFonts.raleway(),
                                                ),
                                                Text(
                                                  userBookings
                                                      .elementAt(index)
                                                      .tipoServizio,
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
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
                                                style: GoogleFonts.raleway(
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

    var realUserBooking = databaseReference
        .collection('User')
        .doc(bookingModel.customerPhone)
        .collection(bookingModel.userCollection)
        .doc(bookingModel.docId.toString());

    batch.delete(userBooking);
    batch.delete(barberBooking);
    batch.delete(barberBookingSlot);
    batch.delete(realUserBooking);

    batch.commit().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Prenotazione Cancellata!')));
      context.read(deleteFlagRefresh).state =
          !context.read(deleteFlagRefresh).state;
    });
  }
}
