import 'package:custom_barber_shop/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserModel> getUserProfiles(String phone) async{
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if(snapshot.exists){
    var userModel = UserModel.fromJson(snapshot.data());
    return userModel;
  }else{
    return UserModel();//return empty user
  }
}