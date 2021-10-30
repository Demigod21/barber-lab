import 'package:custom_barber_shop/cloud_firestore/user_ref.dart';
import 'package:custom_barber_shop/constants/constants.dart';
import 'package:custom_barber_shop/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    return createWelcomeBanner(context, userModel.name);
                    // return Container(
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFF383838),
                    //   ),
                    //   padding: const EdgeInsets.all(16),
                    //   child: Row(
                    //     children: [
                    //       CircleAvatar(
                    //         child: Icon(
                    //           Icons.person,
                    //           color: Colors.white,
                    //           size: 30,
                    //         ),
                    //         backgroundColor: Colors.black,
                    //         maxRadius: 30,
                    //       ),
                    //       SizedBox(
                    //         width: 30,
                    //       ),
                    //       Expanded(
                    //           child: Column(
                    //         children: [
                    //           Text('${userModel.name}',
                    //               style: GoogleFonts.robotoMono(
                    //                 fontSize: 22,
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold,
                    //               )),
                    //           Text('${userModel.address}',
                    //               style: GoogleFonts.robotoMono(
                    //                 fontSize: 14,
                    //                 color: Colors.white,
                    //               ))
                    //         ],
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //       ))
                    //     ],
                    //   ),
                    // );
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
                  height: size.height * 0.20 - 17,
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
          height: 10,
        ),
        Container(
          height: size.height * 0.40-10,
          width: size.width * 0.90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'I nostri orari : ',
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
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
                    '08:00 - 13:30 / 15:00 - 19:00',
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
                    '08:00 - 13:30 / 15:00 - 19:00',
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
                    '08:00 - 13:30 / 15:00 - 19:00',
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
                    '08:00 - 13:30 / 15:00 - 19:00',
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
                    '08:00 - 13:30 / 15:00 - 19:00',
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
        Container(
          height: size.height * 0.40,
          width: size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

            ],
          ),
        )
      ],
    );
  }
}
