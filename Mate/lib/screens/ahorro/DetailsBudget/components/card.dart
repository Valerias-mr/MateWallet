import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardComponentBudget extends StatefulWidget {
  final DocumentSnapshot document;
  final bool isSelected;
  final Function(bool) onCardSelected;

  const CardComponentBudget({
    Key? key,
    required this.document,
    this.isSelected = false,
    required this.onCardSelected,
  }) : super(key: key);

  @override
  _CardComponentBudgetState createState() => _CardComponentBudgetState();
}

class _CardComponentBudgetState extends State<CardComponentBudget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final List<Color> cardColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Color.fromARGB(255, 255, 196, 0)
    ]; // Lista de colores para las tarjetas
    final Color color = cardColors[Random().nextInt(cardColors.length)];
    final String cardNumber = widget.document['cardNumber'];
    final String expiryDate = widget.document['expiryDate'];
    final String balance = widget.document['balance'];

    return GestureDetector(
      onTap: () {
        widget.onCardSelected(!widget.isSelected);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isSelected ? Colors.black : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Container(
              height: size.height * 0.2,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
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
                  Text(
                    "Balance",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
      ),
    );
  }
}
