

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
