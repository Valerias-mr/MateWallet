import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TransactionsComponents/home_screenTransactions.dart';
import 'card.dart';

class CardSectionMovements extends StatelessWidget {
  const CardSectionMovements({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cards')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final cards = snapshot.data!.docs;

        return Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: cards.map((document) {
                      final cardId = document.id;

                      return Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          top: 0,
                        ),
                        child: Transform.rotate(
                          angle: -pi / 2, // Rota 90° hacia arriba (en radianes)
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreenTransactions(
                                    userId: user.uid,
                                    cardId: cardId,
                                  ),
                                ),
                              );
                            },
                            child: CardComponentMovements(document: document),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
