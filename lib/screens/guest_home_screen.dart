import 'package:barber_lab_sabatini/constants/constants.dart';
import 'package:barber_lab_sabatini/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestHome extends StatefulWidget {

  @override
  GuestHomePage createState() => GuestHomePage();
}

class GuestHomePage extends State<GuestHome> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
    appBar: AppBar(
      title: Text('Benvenuto ospite'),
      backgroundColor: Colors.black,
    ),
    body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: size.height * 0.45 - 30,
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
          Container(
            height: size.height * 0.35 - 30,
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
      ),
    )
  );
  }

  Future<void> _launchMaps() async {
    final url =
        'https://goo.gl/maps/Z5ACYLi2nyc8wzo67';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}