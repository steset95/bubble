import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bubble/pages/kita_pages/feed_page_kita.dart';
import 'package:bubble/pages/kita_pages/profile_page_kita.dart';
import 'package:bubble/pages/kita_pages/children_page_kita.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../helper/notification_controller.dart';


class HomePageKita extends StatefulWidget {
  const HomePageKita({super.key});

  @override
  State<HomePageKita> createState() => _HomePageKitaState();
}

class _HomePageKitaState extends State<HomePageKita> {



  int _currentIndex = 0;
  List<Widget> body = [
    FeedPageKita(),
    ChildrenPageKita(),
    ProfilePageKita(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        currentIndex: _currentIndex,
          onTap: (int newIndex)
          {
            setState((){
              _currentIndex = newIndex;
          });
          },
        items: [
          BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome12, color: Colors.grey),
              activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedHome12, color: Colors.indigo.shade500),
              label: "Nástenka"),
          BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedKid, color: Colors.grey),
              activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedKid, color: Colors.indigo.shade500),
              label: "Deti"),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedPassport, color: Colors.grey),
            activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedPassport, color: Colors.indigo.shade500),
            label: "Profil",),
        ],
      ),
    );
  }
}

