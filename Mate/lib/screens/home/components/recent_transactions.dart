import 'package:bankingapp/screens/home/components/transactions.dart';
import 'package:flutter/material.dart';

class RecentTransactionSection extends StatelessWidget {
  const RecentTransactionSection({Key? key}) : super(key: key);

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
          RecentTransactions(),
        ],
      ),
    );
  }
}
