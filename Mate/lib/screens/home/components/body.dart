import 'package:bankingapp/screens/home/components/card_section.dart';
import 'package:bankingapp/screens/home/components/items_actions.dart';
import 'package:bankingapp/screens/home/components/recent_transactions.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: const [
          CardSection(),
          ActionItems(),
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
          RecentTransactionSection()
        ],
      ),
    );
  }
}
