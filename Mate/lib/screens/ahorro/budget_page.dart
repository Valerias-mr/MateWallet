import 'dart:math';

import 'package:bankingapp/json/budget_json.dart';
import 'package:bankingapp/json/day_month.dart';
import 'package:bankingapp/screens/ahorro/DetailsBudget/home_screenBudgetDetails.dart';
import 'package:bankingapp/screens/ahorro/create_budge_page.dart';
import 'package:bankingapp/theme/colors.dart';
import 'package:bankingapp/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeDay = 3;
  List<DocumentSnapshot> budgets = [];
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    fetchBudgets();
  }

  Future<void> fetchBudgets() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('budgets')
          .get();

      setState(() {
        budgets = snapshot.docs;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Color getPercentageColor(double percentage) {
    if (percentage >= 0 && percentage <= 25) {
      return Colors.red;
    } else if (percentage > 25 && percentage <= 50) {
      return Colors.orange;
    } else if (percentage > 50 && percentage <= 75) {
      return Colors.yellow;
    } else if (percentage > 75 && percentage < 100) {
      return Colors.green;
    } else if (percentage == 100) {
      return Colors.pinkAccent;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(userId: user.uid),
        body: getBody());
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: List.generate(budgets.length, (index) {
                var budget = budgets[index];
                var budgetData = budget.data() as Map<String, dynamic>;
                var budgetId = budget.id; // Obtener el ID del budget
                var budgetName = budgetData['nameBudget'];
                var budgetPrice = budgetData['priceBudget'];
                var budgetLabelPercentage = budgetData['label_percentage'];
                var budgetPercentage = budgetData['porcentBudget'];
                var budgetCurrent = budgetPrice * (budgetPercentage / 100);

                double percentage = budgetPercentage.toDouble();
                Color percentageColor = getPercentageColor(percentage);

                return GestureDetector(
                  onTap: () {
                    // Navegar a otra página y pasar el ID del budget seleccionado como parámetro
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreenBudgetDetails(
                          userId: user.uid,
                          budgetId: budgetId,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 25, right: 25, bottom: 25, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              budgetName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d).withOpacity(0.6),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "\$${budgetCurrent.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        budgetLabelPercentage,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    "\$${budgetPrice.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Color(0xff67727d).withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: (size.width - 40),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xff67727d).withOpacity(0.1),
                                  ),
                                ),
                                Container(
                                  width: (size.width - 40) *
                                      (budgetPercentage / 100),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: percentageColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
