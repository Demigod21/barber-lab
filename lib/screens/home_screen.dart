import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget{
  @override
  Widget build(BuildContext context, watch){
    return Scaffold(
      body: Center(
        child: Text('Home Page'),

      )
    );
  }
}