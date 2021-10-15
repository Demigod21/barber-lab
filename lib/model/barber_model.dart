import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel{
  String name;
  
  BarberModel(var name){
    this.name = name;
  }
  
  BarberModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
  }

  DocumentReference reference;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}