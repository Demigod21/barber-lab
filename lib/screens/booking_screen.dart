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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'home_screen.dart';

class Booking extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookingPage();
}

class BookingPage extends State<Booking> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  int step = 1;
  var now = DateTime.now();
  var selectedDate = DateTime.now();
  var selectedTime = '';
  var selectedTimeSlot = -1;
  var selectedTimeCombo = '';
  var selectedTimeSlotCombo = -1;
  var tipoServizio = '';
  var note = '';
  var noteController = TextEditingController();
  int indexRadio = -1;
  bool isCombo = false;

  FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('nero');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: null);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('it', null);
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          NumberStepper(
            activeStep: step - 1,
            direction: Axis.horizontal,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            numbers: [1, 2, 3],
            stepColor: Colors.black,
            activeStepColor: Colors.grey,
            numberStyle: TextStyle(color: Colors.white),
          ),
          Expanded(
            flex: 10,
            child: step == 1
                ? displayServices()
                : step == 2
                    ? displayTimeSlots()
                    : step == 3
                        ? displayConfirm()
                        : Container(),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black
                              ),
                                onPressed: !isPrevSelecatble(step)
                                    ? null
                                    : () => actionPrev(step),
                                child: Text('Indietro')),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black
                                ),
                                onPressed: !isNextSelecatble(step)
                                    ? null
                                    : () => setState(() => this.step++),
                                child: step == 3? Text('Conferma') : Text('Avanti')),
                          ),
                        ],
                      ))))
        ],
      ),
    ));
    throw UnimplementedError();
  }

  displayServices() {
    return Center(
            child: Padding(
                padding: const EdgeInsets.all(40),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    customRadio("BARBA", 0, "", "30"),
                    SizedBox(height: 20),

                    customRadio("CAPELLI", 1, "", "30"),
                    SizedBox(height: 20),

                    customRadio("BARBA E CAPELLI", 2, "", "60"),
                  ],
                )));
  }

  changeIndexRadio(int indexRadio, String txt) {
    if (indexRadio == 2) {
      setState(() {
        this.isCombo = true;
      });
    } else {
      setState(() {
        this.isCombo = false;
      });
    }
    setState(() {
      this.tipoServizio = txt;
    });
    setState(() {
      this.indexRadio = indexRadio;
    });
  }

  customRadio(String txt, int index, String imagePath, String minutes) {
    return OutlinedButton(
        onPressed: () => changeIndexRadio(index, txt),
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          onSurface : Colors.white,
          backgroundColor: Colors.white,
          shadowColor: this.indexRadio == index ? Colors.blueAccent : Colors.black,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          side: BorderSide(
              width: 1,
              color:
                  this.indexRadio == index ? Colors.blueAccent : Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child : Column(children: [
                  Icon(Icons.accessible_forward_sharp,
                      color: this.indexRadio == index
                          ? Colors.blueAccent
                          : Colors.black),
                ]),
              ),

              Expanded(
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(txt,
                            style: GoogleFonts.robotoMono(
                                fontSize: 18,
                                color: this.indexRadio == index
                                    ? Colors.blueAccent
                                    : Colors.black)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: this.indexRadio == index
                              ? Colors.blueAccent
                              : Colors.black),
                      Expanded(
                        child: Text(" "+minutes + " MINUTI",
                            style: GoogleFonts.raleway(
                                fontSize: 16,

                                color: this.indexRadio == index
                                    ? Colors.blueAccent
                                    : Colors.black)),
                      )
                    ],
                  )
                ]),
              )
            ],
          ),
        ));
  }

  displayTimeSlots() {
    return Column(
      children: [
        Container(
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  '${DateFormat.MMMM('it').format(selectedDate)}'
                                      .toUpperCase(),
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${selectedDate.day}',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Text(
                                  '${DateFormat.EEEE('it').format(selectedDate)}'.toUpperCase(),
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.white,
                                      fontSize: 18
                                  ),
                                ),
                              ],
                            )))),
                GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: now,
                          maxTime: now.add(Duration(days: 31)),
                          onConfirm: (date) =>
                              setState(() => this.selectedDate = date));
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            )))),
              ],
            )),
        Expanded(
          child: FutureBuilder(
            future: getTimeSlotLorenzo(
                DateFormat('dd_MM_yyyy').format(selectedDate)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var listTimeSlot = snapshot.data as List<int>;
                return GridView.builder(
                    itemCount: TIME_SLOT.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        childAspectRatio: 1.6),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: !isAvailable(listTimeSlot, index)
                              ? null
                              : () {
                                  if (!isAvailable(listTimeSlot, index)) {
                                    return;
                                  }
                                  var indexDopo = index + 1; //TODO CONTROLLARE ULTIMO SLOT
                                  if (isCombo &&
                                      (listTimeSlot.contains(indexDopo) || index == 99) ) {
                                    Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: 'ATTENZIONE',
                                        desc:
                                            'Non e stato possibile selezionare lo slot attuale poiche si e scelto un tipo di servizio che richiede almeno 2 slot (1h) si prega di selezionarne un altro',
                                        buttons: [
                                          DialogButton(
                                              child: Text('ANNULLA'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ]).show();
                                  } else if (isCombo &&
                                      !listTimeSlot.contains(indexDopo)) {
                                    setState(() {
                                      this.selectedTimeCombo =
                                          TIME_SLOT.elementAt(indexDopo);
                                      this.selectedTimeSlotCombo = indexDopo;
                                      this.selectedTime =
                                          TIME_SLOT.elementAt(index);
                                      this.selectedTimeSlot = index;
                                    });
                                  } else {
                                    setState(() {
                                      this.selectedTime =
                                          TIME_SLOT.elementAt(index);
                                      this.selectedTimeSlot = index;
                                    });
                                  }
                                },
                          child: Card(
                              elevation: 3,
                              shadowColor: !isAvailable(listTimeSlot, index)
                                  ? Colors.black
                                  : this.selectedTime ==
                                              TIME_SLOT.elementAt(index) ||
                                          this.selectedTimeCombo ==
                                              TIME_SLOT.elementAt(index)
                                      ? Colors.blueAccent
                                      : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: !isAvailable(listTimeSlot, index)
                                        ? Colors.grey
                                        : this.selectedTime ==
                                                    TIME_SLOT
                                                        .elementAt(index) ||
                                                this.selectedTimeCombo ==
                                                    TIME_SLOT.elementAt(index)
                                            ? Colors.blueAccent
                                            : Colors.black,
                                    width: 1),
                              ),
                              color: !isAvailable(listTimeSlot, index)
                                  ? Colors.white
                                  : this.selectedTime ==
                                              TIME_SLOT.elementAt(index) ||
                                          this.selectedTimeCombo ==
                                              TIME_SLOT.elementAt(index)
                                      ? Colors.white
                                      : Colors.white,
                              child: GridTile(
                                  child: Center(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                    Text('${TIME_SLOT.elementAt(index)}',
                                        style: GoogleFonts.raleway(
                                            fontSize: 18,
                                            color: !isAvailable(listTimeSlot, index)
                                                ? Colors.grey
                                                : this.selectedTime ==
                                                            TIME_SLOT.elementAt(
                                                                index) ||
                                                        this.selectedTimeCombo ==
                                                            TIME_SLOT.elementAt(
                                                                index)
                                                    ? Colors.blueAccent
                                                    : Colors.black)),
                                    Text(
                                        !isAvailable(listTimeSlot, index)
                                            ? 'Occupato'
                                            : 'Disponibile',
                                        style: GoogleFonts.raleway(
                                            fontSize: 18,
                                            color: !isAvailable(listTimeSlot, index)
                                                ? Colors.grey
                                                : this.selectedTime ==
                                                            TIME_SLOT.elementAt(
                                                                index) ||
                                                        this.selectedTimeCombo ==
                                                            TIME_SLOT.elementAt(
                                                                index)
                                                    ? Colors.blueAccent
                                                    : Colors.black))
                                  ])))),
                        ));
              }
            },
          ),
        )
      ],
    );
  }

  confirmBooking() {
    var hour = selectedTime.length <= 10
        ? selectedTime.split(':')[0].substring(0, 1)
        : selectedTime.split(':')[0].substring(0, 2);
    var minutes = selectedTime.length <= 10
        ? selectedTime.split(':')[1].substring(0, 1)
        : selectedTime.split(':')[0].substring(0, 2);

    setState(() {
      this.note = noteController.text;
    });

    var timeStamp = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(selectedTime.split(':')[0].substring(0, 2)),
      int.parse(selectedTime.split(':')[1].substring(0, 2)),
    ).millisecondsSinceEpoch;
    var timeStampCombo;
    var uuid = Uuid();
    var stringUuid = uuid.v4();
    var uuidSuccessivo = '';
    if (isCombo) {
      uuidSuccessivo = uuid.v4();
    }

    var bookingModel = BookingModel(
        docId: stringUuid,
        customerName: context.read(userInformation).state.name,
        customerPhone: FirebaseAuth.instance.currentUser.phoneNumber,
        barberName: 'LorenzoStaff',
        done: false,
        slot: selectedTimeSlot,
        slotLinkedHourBooking: selectedTimeSlotCombo,
        timeStamp: timeStamp,
        tipoServizio: tipoServizio,
        time:
            '${selectedTime} - ${DateFormat('dd/MM/yyy').format(selectedDate)}',
        note: note,
        uuidLinkedHourBooking: uuidSuccessivo);

    var bookingModelSuccessivo;

    if (isCombo) {
      timeStampCombo = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(selectedTimeCombo.split(':')[0].substring(0, 2)),
        int.parse(selectedTimeCombo.split(':')[1].substring(0, 2)),
      ).millisecondsSinceEpoch;

      bookingModelSuccessivo = BookingModel(
          docId: uuidSuccessivo,
          customerName: context.read(userInformation).state.name,
          customerPhone: FirebaseAuth.instance.currentUser.phoneNumber,
          barberName: 'LorenzoStaff',
          done: false,
          slot: selectedTimeSlotCombo,
          slotLinkedHourBooking: selectedTimeSlot,
          timeStamp: timeStampCombo,
          tipoServizio: tipoServizio,
          time:
              '${selectedTimeCombo} - ${DateFormat('dd/MM/yyy').format(selectedDate)}',
          note: note,
          uuidLinkedHourBooking: stringUuid);
    }

    final databaseReference = FirebaseFirestore.instance;

    DocumentReference barberBookingTimeSlot = databaseReference
        .collection('Barber')
        .doc('LorenzoStaff')
        .collection('${DateFormat('dd_MM_yyyy').format(selectedDate)}')
        .doc(selectedTimeSlot.toString());

    DocumentReference barberBooking = databaseReference
        .collection('Barber')
        .doc('LorenzoStaff')
        .collection('BookingStaff')
        .doc(stringUuid);

    DocumentReference userBooking = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
        .doc(stringUuid);

    if (isCombo) {
      var batchSuccessivo = FirebaseFirestore.instance.batch();
      DocumentReference barberBookingTimeSlotSuccessivo = databaseReference
          .collection('Barber')
          .doc('LorenzoStaff')
          .collection('${DateFormat('dd_MM_yyyy').format(selectedDate)}')
          .doc(selectedTimeSlotCombo.toString());

      DocumentReference barberBookingSuccessivo = databaseReference
          .collection('Barber')
          .doc('LorenzoStaff')
          .collection('BookingStaff')
          .doc(uuidSuccessivo);

      DocumentReference userBookingSuccessivo = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser.phoneNumber)
          .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
          .doc(uuidSuccessivo);
      batchSuccessivo.set(
          barberBookingTimeSlotSuccessivo, bookingModelSuccessivo.toJson());
      batchSuccessivo.set(
          barberBookingSuccessivo, bookingModelSuccessivo.toJson());
      batchSuccessivo.set(
          userBookingSuccessivo, bookingModelSuccessivo.toJson());
      batchSuccessivo.commit();
    }

    var batch = FirebaseFirestore.instance.batch();
    batch.set(barberBookingTimeSlot, bookingModel.toJson());
    batch.set(barberBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());

    batch.commit().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Prenotazione Confermata')));

      _showNotification();


      setState(() {
        this.selectedTimeSlot = -1;
        this.selectedDate = DateTime.now();
        this.selectedTime = '';
        this.step = 1;
        this.selectedTimeSlotCombo = -1;
        this.selectedTimeCombo = '';
        this.tipoServizio = '';
        this.indexRadio = -1;
      });

      setState(() {});
    });
  }

  bool isAvailable(List<int> listTimeSlot, int index) {
    bool output = false;
    output = listTimeSlot.contains(index) ? false : true;
    output = selectedDate.weekday == DateTime.monday ? false : output;
    output = selectedDate.weekday == DateTime.sunday ? false : output;

    if (selectedDate.day == DateTime.now().weekday) {
      if(selectedDate.hour < DateTime.now().hour){
        output = false;
      }else if (selectedDate.hour == DateTime.now().hour){
        if(selectedDate.minute <= DateTime.now().minute){
          output = false;
        }
      }
    }
    return output;
  }

  bool isNextSelecatble(int stepParam){
    if (stepParam == 3){
      return false;
    }
    if(stepParam == 1 && this.tipoServizio == ''){
      return false;
    }
    if(stepParam == 2 && this.selectedTime == ''){
      return false;
    }
    return true;
  }

  bool isPrevSelecatble(int stepParam){
    if(stepParam == 1)
      return false;
    return true;
  }

  void actionPrev(int stepParam){
    if(stepParam == 2){
      setState(() {
        this.selectedTimeSlot = -1;
        this.selectedDate = DateTime.now();
        this.selectedTime = '';
        this.selectedTimeSlotCombo = -1;
        this.selectedTimeCombo = '';
      });
    }
    setState(() {
      this.step--;
    });
  }

  displayConfirm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.asset('assets/images/logo_bianco_rettangolare_1200_600.png')),
        ),
        Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Text('Conferma la tua prenotazione!'.toUpperCase(),
                              style: GoogleFonts.robotoMono(
                                  fontWeight: FontWeight.bold)),
                          Text(
                              'Informazioni sul tuo appuntamento'.toUpperCase(),
                              style: GoogleFonts.robotoMono()),
                          Row(children: [
                            Icon(Icons.calendar_today),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                                '${this.selectedTime} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}'
                                    .toUpperCase(),
                                style: GoogleFonts.robotoMono()),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: new InputDecoration(
                              hintText:
                                  'Inserisci delle note sul tuo appuntamneto',
                            ),
                            controller: noteController,
                          ),
                          ElevatedButton(
                              onPressed: () => confirmBooking(),
                              child: Text('Conferma'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.black)))
                        ])))))
      ],
    );
  }


  _showNotification() async {
    var android = new AndroidNotificationDetails(
        'Reminder Appuntamento', 'Hai un apuntamento da Barber Lab a breve ',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    var scheduledTime = this.selectedDate.subtract(Duration(hours : 3));
    fltrNotification.schedule(1, "Reminder Appuntamento", "Hai un apuntamento da Barber Lab a breve ", scheduledTime, platform);

  }
}
