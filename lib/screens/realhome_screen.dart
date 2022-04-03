import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_lab_sabatini/cloud_firestore/user_ref.dart';
import 'package:barber_lab_sabatini/constants/constants.dart';
import 'package:barber_lab_sabatini/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class RealHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RealHomePage();
}

class RealHomePage extends State<RealHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //user profile
            FutureBuilder(
                future: getUserProfiles(
                    context, FirebaseAuth.instance.currentUser.phoneNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var userModel = snapshot.data as UserModel;

                    if (userModel == null ||
                        userModel.name == null ||
                        userModel.name == '') {
                      Future.delayed(Duration.zero, () => showAlert(context));
                    }
                    return createWelcomeBanner(context, userModel.name);
                  }
                })
          ],
        ),
      ),
    ));
    throw UnimplementedError();
  }

  createWelcomeBanner(BuildContext context, String userName) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.20,
          child: Stack(
            children: [
              Container(
                  height: size.height * 0.20 - 20,
                  width: size.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor,
                          blurRadius: 9,
                        ),
                      ],
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ciao ${userName}!',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        //todo ADD DELETE BUTTON HERE
                      ),
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Benvenuto da BarberLab!',
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor,
                            blurRadius: 9,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: size.height * 0.35 - 30,
          width: size.width * 0.90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Text(
                        'I nostri orari',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              margin:
                                  EdgeInsets.only(right: kDefaultPadding / 2),
                              height: 7,
                              color: kPrimaryColor.withOpacity(0.2)))
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lunedì',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    'CHIUSO',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Martedì',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '08:00 - 13:00 / 15:00 - 19:00',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mercoledì',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '08:00 - 13:00 / 15:00 - 19:00',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Giovedì',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '08:00 - 13:00 / 15:00 - 19:00',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Venerdì',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '08:00 - 13:00 / 15:00 - 19:00',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sabato',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '08:00 - 13:00 / 15:00 - 19:00',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Domenica',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    'CHIUSO',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: size.height * 0.30 - 30,
          width: size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Text(
                        'Dove siamo',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              margin:
                                  EdgeInsets.only(right: kDefaultPadding / 2),
                              height: 7,
                              color: kPrimaryColor.withOpacity(0.2)))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Via Roma, 201',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    'Pontedera 56025 (PI)',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () => {_launchMaps()},
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor,
                          blurRadius: 4,
                        ),
                      ],
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: AssetImage('assets/images/img_def_maps.PNG'),
                          fit: BoxFit.cover)),
                ),
              ))
            ],
          ),
        )
      ],
    );
  }

  Future<void> _launchMaps() async {
    final url = 'https://goo.gl/maps/Z5ACYLi2nyc8wzo67';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var nameProfileController = TextEditingController();

          return AlertDialog(
            title: Text('Aggiorna le tue informazioni personali!'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          hintText: 'Inserisci il tuo nome',
                        ),
                        controller: nameProfileController),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    CollectionReference userRef =
                        FirebaseFirestore.instance.collection('User');
                    DocumentSnapshot snapshot = await userRef
                        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                        .get();
                    userRef
                        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                        .set({
                      'name': nameProfileController.text,
                      'address': ""
                    });
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
                  child: Text('Salva'))
            ],
          );
        });
  }
}
