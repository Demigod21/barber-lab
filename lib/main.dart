import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_lab_sabatini/screens/booking_screen.dart';
import 'package:barber_lab_sabatini/screens/home_screen.dart';
import 'package:barber_lab_sabatini/screens/login_screen.dart';
import 'package:barber_lab_sabatini/screens/realhome_screen.dart';
import 'package:barber_lab_sabatini/screens/user_history_screen.dart';
import 'package:barber_lab_sabatini/screens/user_screen.dart';
import 'package:barber_lab_sabatini/state/state_management.dart';
import 'package:barber_lab_sabatini/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'model/user_model.dart';

import 'dart:developer' as developer;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
                settings: settings,
                child: Home(),
                type: PageTransitionType.fade);
            break;
          case '/login':
            return PageTransition(
                settings: settings,
                child: LoginScreen(),
                type: PageTransitionType.fade);
            break;
          case '/utenti':
            return PageTransition(
                settings: settings,
                child: UserHistory(),
                type: PageTransitionType.fade);
            break;
          case '/prenotazione':
            return PageTransition(
                settings: settings,
                child: Booking(),
                type: PageTransitionType.fade);
            break;
          default:
            return null;
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      initialRoute: FirebaseAuth.instance.currentUser == null? '/login' : '/home',
    );
  }
}


class MyHomePage extends ConsumerWidget {

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  int index = 0;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
        child: Container()
    );
  }



}
