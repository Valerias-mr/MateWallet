import 'package:bankingapp/screens/HistorialGastos/components/CreateTransactionComponents/TransactionCreate.dart';
import 'package:bankingapp/screens/HistorialGastos/components/TransactionsComponents/components/card_section.dart';
import 'package:bankingapp/screens/HistorialGastos/components/TransactionsComponents/components/recent_transactions.dart';
import 'package:flutter/material.dart';

class BodyTransactions extends StatelessWidget {
  final String userId;
  final String cardId;
  const BodyTransactions({Key? key, required this.userId, required this.cardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          Column(
            children: [
              CardSectionTransaction(cardId: cardId, userId: userId),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Transacciones Recientes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: RecentTransactionSectionMovements(
                  userId: userId,
                  cardId: cardId,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransactionCreate(
                            userId: userId,
                            cardId: cardId,
                          )),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
