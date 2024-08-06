
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import 'package:socialmediaapp/pages/agb_page.dart';

import '../helper/helper_functions.dart';
import 'datenschutzrichtlinien_page.dart';


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

  File? file;
  var options = [
    'Kita',
    'Eltern',
  ];
  var _currentItemSelected = "Eltern";
  var rool = "Eltern";
  String adress = "";
  String adress2 = "";
  String tel = "";
  String childcode = "";
  String childcode2 = "";
  String iban = "";
  int guthaben = 0;
  String gruppe1 = "Gruppe 1";
  String gruppe2 = "Gruppe 2";
  String gruppe3 = "Gruppe 3";
  String shownotification = "0";
  String abo = "Probewochen";
  DateTime aboBis = DateTime.now().add(const Duration(days:14));
  String beschreibung = "";


  bool showProgress = false;
  bool visible = false;
  bool checkedValue = false;



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
    else if (checkedValue == false)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("ABGs wurden nicht akzeptiert.", context);
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
    if (userCredential != null && userCredential.user != null && _currentItemSelected == "Eltern") // prüfen ob Felder leer & ob Eltern
        {
      await FirebaseFirestore.instance //Dokument erstellen
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'rool': rool,
        'adress': adress,
        'adress2': adress2,
        'tel': tel,
        'childcode': "",
        'childcode2': "",
        "kitamail": "",
        "shownotification": shownotification,
        "abo": abo,
        "aboBis": aboBis,
        'date': DateTime.now(),
      });
    }
    else if (userCredential != null && userCredential.user != null && _currentItemSelected == "Kita") // prüfen ob Felder leer und ob Kita
        {
      await FirebaseFirestore.instance //Dokument erstellen
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'rool': rool,
        'adress': adress,
        'adress2': adress2,
        'tel': tel,
        'iban': iban,
        'guthaben': guthaben,
        'gruppe1': gruppe1,
        'gruppe2': gruppe2,
        'gruppe3': gruppe3,
        "shownotification": shownotification,
        'beschreibung':  beschreibung,
      });
    }
  }

  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const SizedBox(height: 50,),
              // logo
              Image.asset("assets/images/Logo_1.png", width: 100, height:60),

              // app name
              const SizedBox(height: 25),
              const Text(
                "Registrierung",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 20),

              // Username textfield

              MyTextField(
                hintText: "Name",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 10),

              // Email textfield

              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,

              ),

              const SizedBox(height: 45),

              // password textfield


              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: const Icon(Icons.remove_red_eye,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Passwort",
                        ),
                        obscureText: _obscureText,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 10),

              // password confirm


              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: confirmPwController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Passwort bestätigen",
                        ),
                        obscureText: _obscureText,
                      ),
                    ),

                  ],
                ),
              ),


              const SizedBox(height: 30),


              DropdownButton<String>(
                isDense: true,
                isExpanded: false,
                items: options.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(
                      dropDownStringItem,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValueSelected) {
                  setState(() {
                    _currentItemSelected = newValueSelected!;
                    rool = newValueSelected;
                  });
                },
                value: _currentItemSelected,
              ),



              const SizedBox(height: 10),

              //Register in button
              CheckboxListTile(
                title: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                AGBPage()),
                          );
                        },
                      child: Text("ABGs",
                        style: TextStyle(color: Colors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                        ),
                    const SizedBox(width: 3),
                    Text("& ",
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              DatenschutzrichtlinienPage()),
                        );
                      },
                      child: Text("Datenschutzrichtlinien",
                        style: TextStyle(color: Colors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text("akzeptieren",
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),

              MyButton(
                text: "Registrieren",
                onTap: registerUser,
              ),

              const SizedBox(height: 10),

              // Register here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Account vorhanden? ",
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
