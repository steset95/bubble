import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
primaryColor: Colors.blueAccent.shade200,
  colorScheme: ColorScheme.light(

  primary: Colors.indigo.shade500,
  secondary: Colors.orange.shade300,
  inversePrimary:  Colors.white,
    brightness: Brightness.light,
    ),

    textTheme: ThemeData.light().textTheme.copyWith(
      titleLarge: TextStyle(fontFamily: 'Goulong-Bold'),
      titleMedium: TextStyle(fontFamily: 'Goulong-Bold'),
      titleSmall: TextStyle(fontFamily: 'Goulong',),
      headlineMedium: TextStyle(fontFamily: 'Goulong',),
      headlineSmall: TextStyle(fontFamily: 'Goulong',),
      bodyLarge: TextStyle(fontFamily: 'Goulong',),
      bodyMedium: TextStyle(fontFamily: 'Goulong',),
      bodySmall: TextStyle(fontFamily: 'Goulong',),
      labelLarge: TextStyle(fontFamily: 'Goulong-Bold',),
      labelMedium: TextStyle(fontFamily: 'Goulong',),
      labelSmall: TextStyle(fontFamily: 'Goulong',),


    ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: TextStyle(fontFamily: 'Goli-Bold', color: Colors.white, fontSize: 25,),
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
),


    );

