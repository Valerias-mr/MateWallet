import 'package:bankingapp/screens/HistorialGastos/components/TransactionsComponents/components/transactions.dart';
import 'package:flutter/material.dart';

class RecentTransactionSectionMovements extends StatelessWidget {
  final String userId;
  final String cardId;
  const RecentTransactionSectionMovements({
    Key? key,
    required this.userId,
    required this.cardId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Stack(
        children: [
          RecentTransactionsCardsH(
            userId: userId,
            cardId: cardId,
          ),
        ],
      ),
    );
  }
}
