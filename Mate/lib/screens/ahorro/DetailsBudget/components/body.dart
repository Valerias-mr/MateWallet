import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'card_section.dart';
import 'package:bankingapp/screens/HistorialGastos/components/CreateTransactionComponents/TransactionCreate.dart';
import 'package:bankingapp/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class BodyDetailsBudget extends StatelessWidget {
  final String userId;

  const BodyDetailsBudget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [CardSectionBudget()],
      ),
    );
  }
}
