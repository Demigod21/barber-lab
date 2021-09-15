import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:custom_barber_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart';

class Booking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BookingPage();
}

class BookingPage extends State<Booking>{
  int step = 1;
  var now = DateTime.now();
  var selectedDate = DateTime.now();
  var selectedSlot = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column( children: [
        NumberStepper(
            activeStep: step-1,
          direction: Axis.horizontal,
          enableNextPreviousButtons: false,
          enableStepTapping: false,
          numbers: [1,2,3],
          stepColor: Colors.black,
          activeStepColor: Colors.grey,
          numberStyle: TextStyle(color: Colors.white),
        ),
        Expanded(
          flex: 10,
          child: step == 1? displayTimeSlots()  : Container(),
        ),
        Expanded(child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding : const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child : ElevatedButton(
                    onPressed: step == 1 ? null : ()=> setState(() => this.step--),
                    child: Text('Indietro')
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child : ElevatedButton(
                      onPressed: step == 3 ? null : ()=> setState(() => this.step++),
                      child: Text('Avanti')
                  ),
                ),
              ],
            )
          )
        ))
      ],
      ),
    ));
    throw UnimplementedError();
  }

  displayTimeSlots() {
    return Column(
      children: [
        Container(
          color: Color(0xFF008577),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
                      Text('${DateFormat.MMMM().format(selectedDate)}',
                      style : GoogleFonts.robotoMono(
                        color: Colors.white54,
                      ),
                      ),
                      Text('${selectedDate.day}',
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize : 22
                        ),
                      ),
                      Text('${DateFormat.EEEE().format(selectedDate)}',
                        style : GoogleFonts.robotoMono(
                          color: Colors.white54,
                        ),
                      ),
                    ],)
                  )
                )
              ),
              GestureDetector(
                onTap: (){
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: now,
                    maxTime: now.add(Duration(days: 31)),
                    onConfirm: (date) => setState(() => this.selectedDate = date)
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    )
                  )
                )
              ),
            ],
          )
        ),
        Expanded(
          child: GridView.builder(
            itemCount : TIME_SLOT.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: ()=> setState(() => this.selectedSlot = TIME_SLOT.elementAt(index)),
              child : Card(
                  color : this.selectedSlot == TIME_SLOT.elementAt(index)? Colors.white : Colors.grey,
                  child: GridTile(
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${TIME_SLOT.elementAt(index)}'),
                                Text('Disponibile')
                              ]
                          )
                      )
                  )
              ),
            )

          )
        )
      ],
    );
  }

}