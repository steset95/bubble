import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import 'package:socialmediaapp/helper/helper_functions.dart';

import 'forgot_password_page.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Login MEhtod
  void login() async{
    // ladekreis anzeigen
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ladekreis anzeigen
      if (context.mounted) Navigator.pop(context);
    }
    // Fehlermeldung anzeigen

    on FirebaseAuthException catch (e) {
      // ladekreis anzeigen
      Navigator.pop(context);
      displayMessageToUser("Benutzername oder Passwort falsch", context);

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
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const SizedBox(height: 70,),
              // logo
              Image.asset("assets/images/Logo_1.png", width: 220, height:120),
              // app name
              const SizedBox(height: 60),
              const Text(
                "Login",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 20),

              // Email textfield

              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,

              ),

              const SizedBox(height: 20),

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

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  GestureDetector(
                    child: Text(
                      "Passwort vergessen? ",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //sing in button

              MyButton(
                text: "Login",
                onTap: login,
              ),

              const SizedBox(height: 10),

              // Register here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Noch keinen Account? ",
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Hier registrieren",
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