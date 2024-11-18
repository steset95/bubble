import 'package:flutter/material.dart';

class ProgressWithIcon extends StatelessWidget {
  const ProgressWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/plant.gif')
        ],
      ),
    );
  }
}