import 'package:cade_voce/services/auth_service.dart';
import 'package:cade_voce/services/position_service.dart';
import 'package:cade_voce/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InjectionModule{
  
  static final getIt = GetIt.instance;
  
  static void configure(){
    getIt.registerSingleton(PositionService());
    getIt.registerSingleton<UserService>(UserService(FirebaseFirestore.instance, getIt<PositionService>()));
    getIt.registerSingleton(AuthService(getIt<UserService>(), FirebaseAuth.instance, GoogleSignIn()));
  }
  
}