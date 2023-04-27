import 'package:cade_voce/injection/injection_module.dart';
import 'package:cade_voce/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  final _authService = InjectionModule.getIt<AuthService>();

  AuthPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _authService.signIn();
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
