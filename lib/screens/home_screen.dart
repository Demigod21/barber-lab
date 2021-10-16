import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_barber_shop/cloud_firestore/user_ref.dart';
import 'package:custom_barber_shop/model/user_model.dart';
import 'package:custom_barber_shop/screens/realhome_screen.dart';
import 'package:custom_barber_shop/screens/staff_history_screen.dart';
import 'package:custom_barber_shop/screens/user_history_screen.dart';
import 'package:custom_barber_shop/screens/user_screen.dart';
import 'package:custom_barber_shop/state/state_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'booking_screen.dart';

import 'dart:developer' as developer;


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePage();
}

class HomePage extends State<Home> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    ));
  }

  Widget buildBottomNavigationBar() {
    return BottomNavyBar(
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      // onItemSelected: (index) =>(()=> this.index = index),
      // onItemSelected: {
      //   Navigator.pushNamedAndRemoveUntil(context, '/prenotazione', (route) => false);
      // },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          title: Text('Utente'),
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.book),
          title: Text('Prenota'),
        )
      ],
    );
  }

 buildBody() {


    switch(index){
      case 0:
        return RealHome();
      case 1:
        return StaffHistory();
      case 2:
        return Booking();
      default:
        return RealHome();
    }
  }
}
