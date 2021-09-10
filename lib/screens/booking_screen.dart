import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:im_stepper/stepper.dart';

import 'home_screen.dart';

class Booking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BookingPage();
}

class BookingPage extends State<Booking>{
  int step = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(children: [
        NumberStepper(
          activeStep: step-1,
          direction: Axis.horizontal,
          enableNextPreviousButtons: false,
          enableStepTapping: false,
          numbers: [1,2,3],
          stepColor: Colors.grey,
          activeStepColor: Colors.black,
          numberStyle: TextStyle(color: Colors.white),
        )
      ],
      ),
    ));
    throw UnimplementedError();
  }

}