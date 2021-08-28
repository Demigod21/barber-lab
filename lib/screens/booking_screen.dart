import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

import 'home_screen.dart';

class Booking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BookingPage();
}

class BookingPage extends State<Booking>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Text(
          'Booking',
          style: TextStyle(fontSize: 50),
        ),
      ),
    ));
    throw UnimplementedError();
  }

}