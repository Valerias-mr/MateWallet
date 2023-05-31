import 'package:flutter/material.dart';
import 'card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardSection extends StatelessWidget {
  const CardSection({Key? key}) : super(key: key);

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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cards.map((document) {
              return Padding(
                padding: EdgeInsets.only(left: 20),
                child: CardComponent(document: document),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
