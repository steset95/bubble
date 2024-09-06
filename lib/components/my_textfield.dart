import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;


  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller
});



  @override
  Widget build(BuildContext context) {
    return TextField(
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
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
                  ),
      hintText: hintText,
      ),
      obscureText: obscureText,
    );
  }
}
