
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble/auth/rool_switcher.dart';
import 'package:bubble/auth/login_or_register.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();

}


class _AuthPageState extends State<AuthPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Benutzer ist eingeloggt
        if (snapshot.hasData) {
          return RoolSwitcher();
        }
        // Benutzer ist NICHT eingeloggt

        else {
          return const LoginOrRegister();
        }
      },

      ),
    );
  }
}
