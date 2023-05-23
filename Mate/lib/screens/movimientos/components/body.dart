import 'package:flutter/material.dart';
import 'package:bankingapp/screens/movimientos/components/card_section.dart';
import 'package:bankingapp/screens/movimientos/components/recent_transactions.dart';
import 'package:bankingapp/screens/home/components/card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedTransactionType = "TypeA";
  late Key _recentTransactionsKey;

  @override
  void initState() {
    selectedTransactionType = "TypeB";
    _recentTransactionsKey = ValueKey(selectedTransactionType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          CardSection(
            onTransactionTypeSelected: (String transactionType) {
              setState(() {
                selectedTransactionType = transactionType;
                _recentTransactionsKey = ValueKey(selectedTransactionType);
              });
            },
          ),
          SizedBox(
            height: 50,
          ),
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
            child: RecentTransactionSectionM(
              key: _recentTransactionsKey,
              transactionType: selectedTransactionType,
            ),
          ),
        ],
      ),
    );
  }
}
