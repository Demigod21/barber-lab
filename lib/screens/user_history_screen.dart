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
              return ListView.builder(itemCount: userBookings.length,
                  itemBuilder: (context, index) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  child: Column(
                    children : [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('Data', style: GoogleFonts.robotoMono(),),
                                    Text(DateFormat("dd/MM/yy").format(
                                        DateTime.fromMicrosecondsSinceEpoch(userBookings[index].timeStamp))
                                      , style: GoogleFonts.robotoMono(fontSize: 22, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Orario', style: GoogleFonts.robotoMono(),),
                                    Text(TIME_SLOT.elementAt(userBookings[index].slot)
                                      , style: GoogleFonts.robotoMono(fontSize: 22, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10
                              ),
                              child: Text('CANCELLA', style: GoogleFonts.robotoMono(color: Colors.white)),
                            )
                          ],
                        )
                      )
                    ]
                  ),
                );
              });
            }
          }
        });
  }
}
