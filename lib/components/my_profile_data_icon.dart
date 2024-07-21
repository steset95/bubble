import 'package:flutter/material.dart';

class MyProfileDataIcon extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  final icon;


  const MyProfileDataIcon({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  Container(
      width: mediaQuery.size.width * 1,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
            color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(2, 4),
          ),
          ],
        ),
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 10),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 15,
                ),
              ),
            ],
          ),
          Text(text,
            style: TextStyle(color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
        );
  }
}


