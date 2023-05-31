import 'package:flutter/material.dart';
import 'card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardSectionTransaction extends StatelessWidget {
  final String userId;
  final String cardId;
  const CardSectionTransaction({
    Key? key,
    required this.userId,
    required this.cardId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .doc(cardId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final cardData = snapshot.data!.data();

        if (cardData == null) {
          return Text('No se encontró la tarjeta');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardComponent(document: snapshot.data!),
            ],
          ),
        );
      },
    );
  }
}
