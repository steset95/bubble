import 'package:flutter/material.dart';

// Fehlermeldung für User

void displayMessageToUser(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(message),
        );
      }
  );
}
