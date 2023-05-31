import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentTransactionsCardsH2 extends StatelessWidget {
  const RecentTransactionsCardsH2({Key? key}) : super(key: key);

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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user
                        .uid) // Reemplaza 'userId' con el ID del usuario actualmente logeado
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

                  if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return Text('No hay transacciones disponibles.');
                  }

                  final cards = snapshot.data!.docs;

                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
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

                          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                            return Text('No hay transacciones disponibles.');
                          }

                          final transactions = snapshot.data!.docs;

                          return ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: transactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              final transaction = transactions[index];

                              // Obtener los valores de la transacción
                              final data =
                                  transaction.data() as Map<String, dynamic>;
                              final title = data['title'] ?? '';
                              final image = "assets/images/netflix.png";
                              final description = data['description'] ?? '';
                              final price = data['price'] ?? 0;

                              return RecentTransaction(
                                title: title,
                                image: image,
                                description: description,
                                price: price,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
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
