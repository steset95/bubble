
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_button.dart';
import 'package:bubble/components/my_textfield.dart';

import '../helper/helper_functions.dart';


class RegisterPage extends StatefulWidget {

  //register Methode
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register methode
  void registerUser() async {
    // ladekreis anzeigen
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),

        )
    );

    // passwort übereinstimmung prüfen
    if (passwordController.text != confirmPwController.text)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("Passwörter stimmen nicht überein", context);


    }
    // wenn Passwörter übereinstimmen
    else {
      // Benutzer erstellen
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );


        //// Dokument für Benutzer in Firestore erstellen

        createUserDocument(userCredential);

        //// Dokument für Benutzer in Firestore erstellen

        // Ladekreis

        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Ladekreis
        Navigator.pop(context);

        // Fehlermeldung anzeigen
        displayMessageToUser(e.code, context);
      }
    }
  }

  //// Dokument für Firestone erstellen und mit Benutzerdaten füllen, Name = Users

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) // prüfen ob Felder leer
        {
      await FirebaseFirestore.instance //Dokument erstellen
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              // app name

              const Text(
                "Login",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 80),

              // Username textfield

              MyTextField(
                hinText: "Benutzername",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 10),

              // Email textfield

              MyTextField(
                hinText: "Email",
                obscureText: false,
                controller: emailController,

              ),

              const SizedBox(height: 45),

              // password textfield

              MyTextField(
                hinText: "Password",
                obscureText: true, // Text nicht anzeigen
                controller: passwordController,

              ),

              const SizedBox(height: 10),

              // password confirm

              MyTextField(
                hinText: "Password bestätigen",
                obscureText: true, // Text nicht anzeigen
                controller: confirmPwController,

              ),



              const SizedBox(height: 10),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //Register in button

              MyButton(
                text: "Registrieren",
                onTap: registerUser,
              ),

              const SizedBox(height: 10),

              // Register here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sie haben bereits einen Account? ",
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Hier einloggen",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/