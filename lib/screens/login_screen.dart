import 'dart:ui';

import 'package:custom_barber_shop/screens/policy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Autentificazione via cellulare'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Image.asset(
                    'assets/images/logo_bianco_rettangolare_1200_600.png')),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Center(
                child: Text(
                  'Autentificazione via cellulare',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, right: 10, left: 10, bottom: 70),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Numero di telefono ',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+39'),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            )
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                          'Clickando su avanti e registrando un account, si presta consenso\n',
                          style: GoogleFonts.raleway(
                              fontSize: 12, color: Colors.black),
                          children: [
                            TextSpan(
                                style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                text: 'alle condizioni presenti nella Privacy Policy',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PolicyDialog(
                                          mdFileName: 'privacy_policy_en.md',
                                        );
                                      },
                                    );
                                  })
                          ]))),
              Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                child: FlatButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OTPScreen(_controller.text)));
                  },
                  child: Text(
                    'Avanti',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
