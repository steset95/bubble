import 'package:flutter/material.dart';

// in Register & Login Page


class MyButton extends StatelessWidget {

  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,

});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(25),
        child: Center(
         child: Text(
           text,
           style: const TextStyle(
           fontWeight: FontWeight.bold,
             fontSize: 16,
             color: Colors.white
           ),
         ),
        ),
      ),
    );
  }
}
