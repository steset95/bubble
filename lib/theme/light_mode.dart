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
      titleLarge: TextStyle(fontFamily: 'Goli-Medium'),
      titleMedium: TextStyle(fontFamily: 'Goli-Regular'),
      titleSmall: TextStyle(fontFamily: 'Goli',),
      headlineMedium: TextStyle(fontFamily: 'Goli',),
      headlineSmall: TextStyle(fontFamily: 'Goli',),
      bodyLarge: TextStyle(fontFamily: 'Goli',),
      bodyMedium: TextStyle(fontFamily: 'Goli',),
      bodySmall: TextStyle(fontFamily: 'Goli',),
      labelLarge: TextStyle(fontFamily: 'Goli-Medium',),
      labelMedium: TextStyle(fontFamily: 'Goli',),
      labelSmall: TextStyle(fontFamily: 'Goli',),


    ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: TextStyle(fontFamily: 'Goli-Bold', color: Colors.white, fontSize: 25,),
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
),


    );

