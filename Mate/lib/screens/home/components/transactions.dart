import 'package:bankingapp/json/create_budget_json.dart';
import 'package:bankingapp/screens/gestion_gastos/edit_gestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentTransactionsCardsH2 extends StatelessWidget {
  const RecentTransactionsCardsH2({Key? key}) : super(key: key);

  void handleTransactionTap(
      DocumentSnapshot<Object?> transaction, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransaction(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 3 * (60),
              child: ListView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('cards')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final cards = snapshot.data!.docs;

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          final card = cards[index];

                          return StreamBuilder<QuerySnapshot>(
                            stream: card.reference
                                .collection('transactions')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              final transactions = snapshot.data!.docs;

                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final transaction = transactions[index];

                                  return GestureDetector(
                                    onTap: () {
                                      handleTransactionTap(
                                          transaction, context);
                                    },
                                    child: RecentTransaction(
                                      title: transaction['title'] ?? '',
                                      description:
                                          transaction['description'] ?? '',
                                      category: transaction['category'] ?? '',
                                      price: transaction['price'] ?? 0,
                                      typeTransaction:
                                          transaction['typeTransaction'] ?? '',
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
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

class RecentTransaction extends StatelessWidget {
  const RecentTransaction({
    Key? key,
    required this.title,
    required this.category,
    required this.price,
    required this.typeTransaction,
    this.description,
  }) : super(key: key);

  final String title, category, typeTransaction;
  final String? description;
  final int price;

  @override
  Widget build(BuildContext context) {
    Color iconColor = typeTransaction == "-" ? Colors.red : Colors.green;
    IconData iconData =
        typeTransaction == "-" ? Icons.arrow_back : Icons.arrow_forward;
  
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    iconData,
                    color: iconColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    category,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "$typeTransaction \$$price",
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
