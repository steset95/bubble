import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MyProfileDataIconNoFunction extends StatelessWidget {
  final String text;
  final String sectionName;


  const MyProfileDataIconNoFunction({
    super.key,
    required this.text,
    required this.sectionName,
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
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,),
              ),
              if (text == "erlaubt")
              Container(
                width: 30,
                height: 30,
                child:
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                  color: Colors.green,
                  size: 20,
                ),

              ),
              if (text == "nicht erlaubt")
                Container(
                  width: 30,
                  height: 30,
                  child:
                  Icon(
                    Icons.block,
                    color: Colors.redAccent,
                    size: 20,
                  ),

                ),
            ],
          ),
        ],
      ),
        );
  }
}


