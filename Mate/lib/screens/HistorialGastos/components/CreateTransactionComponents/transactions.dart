import 'package:flutter/material.dart';

class RecentTransactionsCardCreate extends StatelessWidget {
  final String title;
  final String category;
  final String typeTransaction;

  final int price;

  const RecentTransactionsCardCreate({
    Key? key,
    required this.title,
    required this.category,
    required this.price,
    required this.typeTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        children: [
          RecentTransactionCreate(
            title: title,
            category: category,
            price: price,
            typeTransaction: typeTransaction,
          ),
        ],
      ),
    );
  }
}

class RecentTransactionCreate extends StatelessWidget {
  const RecentTransactionCreate({
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
