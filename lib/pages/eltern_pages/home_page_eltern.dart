
import 'package:flutter/material.dart';
import 'package:bubble/pages/eltern_pages/profile_page_eltern.dart';
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.house_outlined), label: "Škôlka",),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Denník"),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: "Dieťa"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profil"),
                    ],
      ),

    );
  }
}


