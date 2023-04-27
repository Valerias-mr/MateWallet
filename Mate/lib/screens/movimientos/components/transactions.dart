import 'package:flutter/material.dart';

class RecentTransactionsMovements extends StatelessWidget {
  final List<RecentTransaction> transactions;

  const RecentTransactionsMovements({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 6 * (59 + 10),
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return transactions[index];
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecentTransaction extends StatelessWidget {
  const RecentTransaction({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  final String image, title, description;
  final int price;

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: AssetImage(image),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text(
                    "$description",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text("- \$$price",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

class Transactions extends StatelessWidget {
  final List<RecentTransaction> transactions;

  const Transactions({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        SizedBox(height: 10.0),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactions.length,
          itemBuilder: (BuildContext context, int index) {
            return transactions[index];
          },
        ),
      ],
    );
  }
}
