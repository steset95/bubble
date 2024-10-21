
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bubble/pages/eltern_pages/profile_page_eltern.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../helper/abo_controller.dart';
import 'child_page_eltern.dart';
import 'feed_page_eltern.dart';
import 'infos_kind_page_eltern.dart';


class HomePageEltern extends StatefulWidget {
  const HomePageEltern({super.key});

  @override
  State<HomePageEltern> createState() => _HomePageElternState();
}

class _HomePageElternState extends State<HomePageEltern> {


  int _currentIndex = 0;
  List<Widget> body = [
    FeedPageEltern(),
    ChildPageEltern(),
    InfosKindPageEltern(),
    ProfilePageEltern(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
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
             label: "Škôlka",),
          BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: Colors.grey),
              activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: Colors.indigo.shade500),
              label: "Denník"),
          BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedKid, color: Colors.grey),
              activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedKid, color: Colors.indigo.shade500),
              label: "Dieťa"),
          BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedPassport, color: Colors.grey),
              activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedPassport, color: Colors.indigo.shade500),
              label: "Profil"),
                    ],
      ),

    );
  }
}


