import 'package:cade_voce/injection/injection_module.dart';
import 'package:cade_voce/pages/auth/auth_page.dart';
import 'package:cade_voce/pages/map/map_page.dart';
import 'package:cade_voce/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  InjectionModule.configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authService = InjectionModule.getIt<AuthService>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder<User?>(
          initialData: null,
          stream: _authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return const MapPage();
            } else {
              return AuthPage();
            }
          },
        ),
      ),
    );
  }
}
