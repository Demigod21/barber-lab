import 'package:barber_lab_sabatini/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserC extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => UserPage();
}

class UserPage extends State<UserC>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Text(
          'User',
          style: TextStyle(fontSize: 50),
        ),
      ),
    ));
    throw UnimplementedError();
  }

}