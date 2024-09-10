import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_button.dart';
import 'package:bubble/components/my_textfield.dart';
import 'package:bubble/helper/helper_functions.dart';

import 'forgot_password_page.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
        email: email.text,
        password: password.text,
      );
      // ladekreis anzeigen
      if (context.mounted) Navigator.pop(context);
    }
    // Fehlermeldung anzeigen

    on FirebaseAuthException catch (e) {
      // ladekreis anzeigen
      Navigator.pop(context);
      displayMessageToUser("Nesprávne používateľské meno alebo heslo", context);

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
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(

        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height),
          child:  IntrinsicHeight(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(child: Image.asset("assets/images/bubbles_login.png", width: mediaQuery.size.width * 0.8,)),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
            
                    children: [
                      // logo
                      Image.asset("assets/images/Logo_1.png", width: 220, height:120),
                      // app name
                      const SizedBox(height: 60),
                      const Text(
                        "Prihlásenie",
                        style: TextStyle(fontSize: 20),
            
                      ),
            
                      const SizedBox(height: 20),
            
                      // Email textfield
            
            
                    TextField(
                      contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                        // If supported, show the system context menu.
                        if (SystemContextMenu.isSupported(context)) {
                          return SystemContextMenu.editableText(
                            editableTextState: editableTextState,
                          );
                        }
                        // Otherwise, show the flutter-rendered context menu for the current
                        // platform.
                        return AdaptiveTextSelectionToolbar.editableText(
                          editableTextState: editableTextState,
                        );
                      },
                      style: TextStyle(color: Colors.black),
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Email",
                      ),
                      obscureText: false,
                    ),
            
                      const SizedBox(height: 20),
            
                      // password textfield
            
                      Container(
            
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                controller: password,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: _toggle,
                                    icon: const Icon(Icons.remove_red_eye,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: "Prihlasovací kód",
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
                              "Zabudli ste prihlasovací kód? ",
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
                        text: "Prihlásiť",
                        onTap: login,
                      ),
            
                      const SizedBox(height: 10),
            
                      // Register here
            
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Nemáte účet? ",
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Zaregistrujte sa tu",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}