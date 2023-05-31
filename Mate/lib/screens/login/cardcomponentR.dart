import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardComponent extends StatelessWidget {
  final Color color;
  final String cardNumber;
  final String expiryDate;
  final String balance;

  const CardComponent({
    Key? key,
    required this.color,
    required this.cardNumber,
    required this.expiryDate,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(right: 10),
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
                  cardNumber,
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
              expiryDate,
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
                Text("Balance", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                Text(
                  "\$ $balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
