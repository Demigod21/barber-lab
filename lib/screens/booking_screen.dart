import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_barber_shop/cloud_firestore/user_ref.dart';
import 'package:custom_barber_shop/model/barber_model.dart';
import 'package:custom_barber_shop/model/booking_model.dart';
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
import 'package:uuid/uuid.dart';

import 'home_screen.dart';

class Booking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BookingPage();
}

class BookingPage extends State<Booking>{
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  int step = 1;
  var now = DateTime.now();
  var selectedDate = DateTime.now();
  var selectedTime = '';
  var selectedTimeSlot = -1;
  var note = '';
  var noteController = TextEditingController();
  int indexRadio = -1;


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
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
          child: step == 1? displayServices() : step == 2? displayTimeSlots()  :
                  step == 3? displayConfirm() : Container(),
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

  displayServices(){
    return Center(
      child: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            customRadio("BARBA", 0),
            customRadio("CAPELLI", 1),
            customRadio("BARBA E CAPELLI", 2),
          ],
        )
      )
    );
  }

  changeIndexRadio(int indexRadio){
    setState(() {
      this.indexRadio = indexRadio;
    });
  }

  customRadio(String txt, int index){
    return OutlinedButton(
        onPressed: () => changeIndexRadio(index),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          side: BorderSide(
              width: 1,
              color: this.indexRadio == index? Colors.cyan : Colors.grey
          ),
        ),
        child: Text(txt, style: GoogleFonts.robotoMono(color: this.indexRadio == index? Colors.cyan : Colors.grey))
    );
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
          child: FutureBuilder(
            future: getTimeSlotLorenzo(DateFormat('dd_MM_yyyy').format(selectedDate)),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else{
                var listTimeSlot = snapshot.data as List<int>;
                return GridView.builder(
                    itemCount : TIME_SLOT.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: listTimeSlot.contains(index)? null : (){
                        setState(() {
                          this.selectedTime = TIME_SLOT.elementAt(index);
                          this.selectedTimeSlot = index;
                        });
                      },
                      child : Card(
                          color : listTimeSlot.contains(index)? Colors.white10 : this.selectedTime == TIME_SLOT.elementAt(index)? Colors.white : Colors.grey,
                          child: GridTile(
                              child: Center(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${TIME_SLOT.elementAt(index)}'),
                                        Text(listTimeSlot.contains(index)? 'Non disponibile' : 'Disponibile')
                                      ]
                                  )
                              )
                          )
                      ),
                    )
                );
              }
            },
          ),
        )
      ],
    );
  }

  confirmBooking() {
    var hour = selectedTime.length <= 10 ? selectedTime.split(':')[0].substring(0,1) : selectedTime.split(':')[0].substring(0,2);
    var minutes = selectedTime.length <= 10 ? selectedTime.split(':')[1].substring(0,1) : selectedTime.split(':')[0].substring(0,2);

    setState(() {
      this.note = noteController.text;
    });

    var timeStamp = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,

      int.parse(selectedTime.split(':')[0].substring(0,2)),
      int.parse(selectedTime.split(':')[1].substring(0,2)),
    ).millisecondsSinceEpoch;
    var uuid = Uuid();
    var stringUuid =uuid.v4();
    var bookingModel = BookingModel(
      docId: stringUuid,
        customerName: context.read(userInformation).state.name,
    customerPhone: FirebaseAuth.instance.currentUser.phoneNumber,
    barberName : 'LorenzoStaff',
    done: false,
    slot: selectedTimeSlot,
    timeStamp : timeStamp,
    time : '${selectedTime} - ${DateFormat('dd/MM/yyy').format(selectedDate)}',
    note : note,
    );

    final databaseReference = FirebaseFirestore.instance;

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference barberBookingTimeSlot = databaseReference.collection('Barber').doc('LorenzoStaff').collection('${DateFormat('dd_MM_yyyy').format(selectedDate)}')
        .doc(selectedTimeSlot.toString());

    DocumentReference barberBooking = databaseReference.collection('Barber').doc('LorenzoStaff').collection('BookingStaff')
        .doc(stringUuid);

    DocumentReference userBooking = FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser.phoneNumber)
    .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
    .doc(stringUuid);

    batch.set(barberBookingTimeSlot, bookingModel.toJson());
    batch.set(barberBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value){

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(SnackBar(
          content: Text ('Prenotazione Confermata')
      ));

      setState(() {
        this.selectedTimeSlot = -1;
        this.selectedDate = DateTime.now();
        this.selectedTime = '';
        this.step = 1;
      });

      setState(() {
      });
    });

  }

  bool isAvailable(List<int> listTimeSlot, int index){
    bool output = false;
    output = listTimeSlot.contains(index)? false : true;
    output = selectedDate.weekday == DateTime.monday? false : output;
    if(selectedDate.day == DateTime.now().weekday){
      //todo implementare
    }
    return output;
  }

  displayConfirm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset('assets/images/logo.png')
          ),
        ),
        Expanded(
          child:Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child : Column(
                    children: [
                      Text('Conferma la tua prenotazione!'.toUpperCase(),
                        style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold)),
                      Text('Informazioni sul tuo appuntamento'.toUpperCase(),
                          style: GoogleFonts.robotoMono()),
                      Row(children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 20,),
                        Text('${this.selectedTime} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}'.toUpperCase(),
                            style: GoogleFonts.robotoMono()),
                      ]),
                      SizedBox(height: 10,),
                      TextField(
                        decoration : new InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Inserisci delle note sul tuo appuntamneto',
                        ),
                        controller: noteController,
                      ),
                      ElevatedButton(onPressed: ()=> confirmBooking(),
                      child: Text('Conferma'),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)))
                    ]
              )
            ))
          )
        )
      ],
    );
  }

}