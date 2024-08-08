import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmediaapp/pages/kita_pages/feed_page_kita.dart';
import 'package:socialmediaapp/pages/kita_pages/profile_page_kita.dart';
import 'package:socialmediaapp/pages/kita_pages/children_page_kita.dart';


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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.house), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: "Kinder"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profil",),
        ],
      ),
    );
  }
}


