import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:custom_barber_shop/cloud_firestore/user_ref.dart';
import 'package:custom_barber_shop/model/user_model.dart';
import 'package:custom_barber_shop/screens/realhome_screen.dart';
import 'package:custom_barber_shop/screens/staff_history_screen.dart';
import 'package:custom_barber_shop/screens/user_history_screen.dart';
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
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      body: builldBody2(),
      bottomNavigationBar: buildBottomNavigationBar(),
    ));
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
            bool isStaff = userModel.isStaff;
            switch (index) {
              case 0:
                return RealHome();
              case 1:
                if(isStaff){
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
