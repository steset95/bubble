import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MyProfileDataIconDelete extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;


  const MyProfileDataIconDelete({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
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
              Flexible(
                child: Text(sectionName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,),
                ),
              ),
              SizedBox(
                width: 30,
                height: 30,
                //padding: const EdgeInsets.only(left: 15, bottom: 15, right: 10),
                child: IconButton(
                  onPressed: onPressed,
                  icon:
                    HugeIcon(
                        icon: HugeIcons.strokeRoundedDelete02,
                        color: Theme.of(context).colorScheme.primary,
                        size: 15,
                    ),
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


