import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentTransactionsCardsH extends StatelessWidget {
  final String userId;
  final String cardId;

  const RecentTransactionsCardsH({
    Key? key,
    required this.userId,
    required this.cardId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId) // Reemplaza 'userId' por el ID del usuario actual
            .collection('cards')
            .doc(cardId) // Reemplaza 'cardId' por el ID de la tarjeta actual
            .collection('transactions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final transactions = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 3 * (60),
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];

                        return RecentTransaction(
                          title: transaction['title'],
                          image: "assets/images/netflix.png",
                          description: transaction['description'],
                          price: transaction['price'],
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(); // Mostrar espacio en blanco
          }
        },
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
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "- \$$price",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
