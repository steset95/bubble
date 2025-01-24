
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_button.dart';
import 'package:bubble/components/my_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

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

  File? file;
  var options = [
    'Škôlka',
    'Rodič',
  ];
  var _currentItemSelected = "Rodič";
  var rool = "Eltern";
  bool checkMeldung = false;
  String adress = "";
  String adress2 = "";
  String tel = "";
  String childcode = "";
  String childcode2 = "";
  int guthaben = 0;
  String gruppe1 = "Skupina 1";
  String gruppe2 = "Skupina 2";
  String gruppe3 = "Skupina 3";
  String shownotification = "0";
  String abo = "Probemonate";
  DateTime aboBis = DateTime.now().add(const Duration(days:90));
  int aboID = DateTime.now().millisecondsSinceEpoch;
  String beschreibung = "";
  int anzahlKinder = 0;



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

    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);

    bool hasDigits = passwordController.text.contains(RegExp(r'[0-9]'));
    bool hasMinLength = passwordController.text.length > 8;


    // passwort übereinstimmung prüfen
    if (passwordController.text != confirmPwController.text)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("Heslá sa nezhodujú", context);


    }

    else if (checkedValue == false)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("ABG neboli akceptované", context);
    }

    else if (emailValid == false)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("Neplatná e-mailová adresa", context);
    }

    else if (hasDigits == false ||  hasMinLength == false)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("Heslo je príliš slabé", context);
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


        if (!mounted) return; Navigator.pop(context);
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
    if (userCredential != null && userCredential.user != null && _currentItemSelected == "Rodič") // prüfen ob Felder leer & ob Eltern
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
        "checkmeldung": checkMeldung,
        'notificationBlock': "",
        'date': DateTime.now(),
        'notificationNumber': 0,
      });
    }
    else if (userCredential != null && userCredential.user != null && _currentItemSelected == "Škôlka") // prüfen ob Felder leer und ob Kita
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
        'guthaben': guthaben,
        "checkmeldung": checkMeldung,
        'gruppe1': gruppe1,
        'gruppe2': gruppe2,
        'gruppe3': gruppe3,
        'beschreibung':  beschreibung,
        'anzahlKinder1': anzahlKinder,
        'anzahlKinder2': anzahlKinder,
        'anzahlKinder3': anzahlKinder,
        'notificationBlock': "",
        "abo": abo,
        "aboBis": aboBis,
        "aboID": aboID,
      });
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .collection("Einwilligungen_Felder")
          .doc("Fotky pre aplikáciu")
          .set({
        'titel': "Fotky pre aplikáciu",
        'value': "",
      });
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .collection("Einwilligungen_Felder")
          .doc("Lakovanie nechtov")
          .set({
        'titel': "Lakovanie nechtov",
        'value': "",
      });
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .collection("Einwilligungen_Felder")
          .doc("Nanášanie opaľovacieho krému")
          .set({
        'titel': "Nanášanie opaľovacieho krému",
        'value': "",
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

      backgroundColor: Theme.of(context).colorScheme.surface,
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
                "Registrácia",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 20),

              // Username textfield

              MyTextField(
                hintText: "Meno",
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


              Row(
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
                        hintText: "Heslo",
                      ),
                      obscureText: _obscureText,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 10),

              // password confirm


              Row(
                children: [
                  Flexible(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: confirmPwController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Zopakujte Heslo",
                      ),
                      obscureText: _obscureText,
                    ),
                  ),

                ],
              ),


              const SizedBox(height: 30),


              InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  labelText: 'Rodič/Škôlka',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
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
                        if (newValueSelected == "Škôlka") {
                          rool = "Kita";
                        }
                      });
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),



              const SizedBox(height: 10),

              //Register in button
              CheckboxListTile(
                title: Row(
                  children: [
                    Text("Akceptujem  ",
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          await launchUrl(
                          Uri.parse('https://bubble-app.ch/terms_and_conditions')); // Add URL which you want here
                          // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                          },
                      child: Text("AGB",
                        style: TextStyle(color: Colors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                        ),
                    Text("  &  ",
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(
                            Uri.parse('https://bubble-app.ch/privacy_policy')); // Add URL which you want here
                        // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: Text("Ochranu Osobných",
                        style: TextStyle(color: Colors.lightBlue,
                          fontSize: 12,
                        ),
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
                text: "Registrovať",
                onTap: registerUser,
              ),

              const SizedBox(height: 10),

              // Register here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Máťe už účet? ",
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Tu sa prihlásite",
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
