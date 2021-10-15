

import 'package:custom_barber_shop/model/barber_model.dart';
import 'package:custom_barber_shop/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => '');
final forceReload = StateProvider((ref) => false);

final currentStep = StateProvider((ref) => 1);

final userInformation = StateProvider((ref) => UserModel());

final selectedBarber = StateProvider((ref) => BarberModel('Lorenzo'));

final deleteFlagRefresh = StateProvider((ref) => false);