import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:barber_lab_sabatini/cloud_firestore/user_ref.dart';
import 'package:barber_lab_sabatini/model/user_model.dart';
import 'package:barber_lab_sabatini/screens/realhome_screen.dart';
import 'package:barber_lab_sabatini/screens/staff_history_screen.dart';
import 'package:barber_lab_sabatini/screens/user_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFDFDFDF),
          body: builldBody2(),
          bottomNavigationBar: buildBottomNavigationBar(),
        )),
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
              (index) => setState(() => this.index = 0);
              return false;
        });
  }

  Widget buildBottomNavigationBar() {
    return BottomNavyBar(
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          textAlign: TextAlign.center,
          inactiveColor: Colors.black87,
          activeColor: Colors.black,
          title: Text('Home'),
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          textAlign: TextAlign.center,
          inactiveColor: Colors.black87,
          activeColor: Colors.black,
          title: Text('Profilo'),
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.book),
          textAlign: TextAlign.center,
          inactiveColor: Colors.black87,
          activeColor: Colors.black,
          title: Text('Prenota'),
        )
      ],
    );
  }

  builldBody2() {
    return FutureBuilder(
        future: getUserProfiles(
            context, FirebaseAuth.instance.currentUser.phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var userModel = snapshot.data as UserModel;
            bool isStaff = false;
            if (userModel != null) {
              isStaff = userModel.isStaff;
            }
            switch (index) {
              case 0:
                return RealHome();
              case 1:
                if (isStaff) {
                  return StaffHistory();
                }
                return UserHistory();
              case 2:
                return Booking();
              default:
                return RealHome();
            }
          }
        });
  }

  buildBody() {
    switch (index) {
      case 0:
        return RealHome();
      case 1:
        return UserHistory();
      case 2:
        return Booking();
      default:
        return RealHome();
    }
  }
}
