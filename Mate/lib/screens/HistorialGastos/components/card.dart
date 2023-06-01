import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardComponentMovements extends StatelessWidget {
  final DocumentSnapshot document;

  const CardComponentMovements({Key? key, required this.document})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final List<Color> cardColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Color.fromARGB(136, 255, 235, 59),
    ]; // Lista de colores para las tarjetas
    final Color color = cardColors[Random().nextInt(cardColors.length)];
    final String cardNumber = document['cardNumber'];
    final String expiryDate = document['expiryDate'];
    final double balanceValue = document['balance'].toDouble();
    final String balance = balanceValue.toString();

    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            height: size.height * 0.3,
            width: size.width * 1.6,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/mastercard.svg"),
                SizedBox(width: 10),
                Text(cardNumber,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Positioned(
            top: 25,
            right: 25,
            child: Text(expiryDate,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
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
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
