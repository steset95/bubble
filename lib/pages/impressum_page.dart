

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ImpressumPage extends StatefulWidget {


  const ImpressumPage({super.key});

  @override
  State<ImpressumPage> createState() => ImpressumPageState();
}

class ImpressumPageState extends State<ImpressumPage> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    title: Text("Impressum",
    ),
    ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      child: Image.asset("assets/images/bubbles_login.png", width: 350, height:350)),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/Logo_1.png", width: 150, height:80),
                    const SizedBox(height: 25),
                    Column(
                      children: [
                        const Text(
                          "Informácie o applikácii",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Vision GmbH",
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          "Gewerbestrasse 3",
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          "8500 Frauenfeld",
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          "Switzerland CH",
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "info@bubble-app.ch",
                          style: TextStyle(fontSize: 12),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await launchUrl(
                                    Uri.parse('https://bubble-app.sk/privacy_policy')); // Add URL which you want here
                                // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                              },
                              child: Text("Ochrana súkromia",
                                  style: TextStyle(fontSize: 10),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await launchUrl(
                                    Uri.parse('https://bubble-app.sk/terms_and_conditions')); // Add URL which you want here
                                // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                              },
                              child: Text("AGB",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            if (Platform.isIOS)
                              TextButton(
                                onPressed: () async {
                                  await launchUrl(
                                      Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')); // Add URL which you want here
                                  // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                                },
                                child: Text("EULA",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                Row(
                  children: [
                    Image.asset("assets/images/swiss.png", width: 20, height:20),
                    const Text(
                      "  made in Switzerland",
                      style: TextStyle(fontSize: 12),
                    ),

                  ],
                ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

