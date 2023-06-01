import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/appbar.dart';
import 'components/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenBudgetDetails extends StatelessWidget {
  final String userId;
  final String budgetId;

  const HomeScreenBudgetDetails(
      {Key? key, required this.userId, required this.budgetId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> selectedCardNotifier =
        ValueNotifier<String?>(null);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [BodyDetailsBudget(userId: userId)],
      ),
      appBar: MyAppBar(userId: userId),
    );
  }
}
