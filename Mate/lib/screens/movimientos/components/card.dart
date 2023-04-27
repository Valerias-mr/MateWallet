import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardComponent extends StatelessWidget {
  const CardComponent({
    Key? key,
    required this.color,
    required this.transactionType,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final String transactionType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : null,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Stack(
          children: [
            Container(
              height: size.height * 0.2,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/mastercard.svg"),
                  SizedBox(width: 10),
                  Text(
                    "**** 2236",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 25,
              right: 25,
              child: Text(
                "02/24",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "\$ 5 300.0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
