import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/appbar.dart';
import 'components/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenTransactions extends StatelessWidget {
  final String userId;
  final String cardId;

  const HomeScreenTransactions(
      {Key? key, required this.userId, required this.cardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [BodyTransactions(userId: userId, cardId: cardId)],
      ),
      appBar: MyAppBar(userId: userId),
    );
  }
}
