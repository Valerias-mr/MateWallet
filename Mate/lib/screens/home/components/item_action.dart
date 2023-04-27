import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.press,
    required this.navigate,
  }) : super(key: key);

  final String iconPath;
  final String title;
  final VoidCallback press;
  final Function navigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            navigate(context);
            press();
          },
          child: Container(
            height: 62,
            width: 62,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 8),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.22),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: SvgPicture.asset(
              iconPath,
              height: 25,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(title, style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)))
      ],
    );
  }
}
