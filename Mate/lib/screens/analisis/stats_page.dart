import 'package:bankingapp/json/day_month.dart';
import 'package:bankingapp/theme/colors.dart';
import 'package:bankingapp/widgets/appbar.dart';
import 'package:bankingapp/widgets/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../../widgets/donut_charts.dart';
import '../../widgets/percent_indicator.dart';
import '../../widgets/wave_progress.dart';

const double baseHeight = 650.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

class StatsPage extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<QueryDocumentSnapshot> budgets = [];
  double totalBudgets = 0;
  double totalCreditCardsBalance = 0;
  double totalIncomeTransaction = 0;
  double totalExpenseTransaction = 0;

  late Future<void> fetchBudgetsFuture;
  late Future<void> fetchTotalBudgetsFuture;
  late Future<void> fetchTotalCreditCardsBalanceFuture;
  late Future<void> fetchTotalTransactionIncomeFuture;
  late Future<void> fetchTotalTransactionExpenseFuture;

  @override
  void initState() {
    super.initState();
    fetchBudgetsFuture = fetchBudgets();
    fetchTotalBudgetsFuture = fetchTotalBudgets();
    fetchTotalCreditCardsBalanceFuture = fetchTotalCreditCardsBalance();
    fetchTotalTransactionIncomeFuture = fetchTransactionIncome();
    fetchTotalTransactionExpenseFuture = fetchTransactionExpense();
  }

  Future<void> fetchBudgets() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('budgets')
          .get();

      setState(() {
        budgets = snapshot.docs;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchTotalBudgets() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('budgets')
          .get();

      double total = 0;

      for (final budgetDoc in snapshot.docs) {
        final budgetData = budgetDoc.data() as Map<String, dynamic>;
        if (budgetData != null) {
          final priceBudget = budgetData['priceBudget'] ?? 0;
          total += priceBudget.toDouble();
        }
      }

      setState(() {
        totalBudgets = total;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchTotalCreditCardsBalance() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('cards')
          .get();

      double totalBalance = 0;

      for (final cardDoc in snapshot.docs) {
        final cardData = cardDoc.data() as Map<String, dynamic>;
        final balance = cardData['balance'] ?? 0;
        totalBalance += balance.toDouble();
      }

      setState(() {
        totalCreditCardsBalance = totalBalance;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchTransactionExpense() async {
    try {
      final String userId = widget.user.uid; // ID del usuario actual
      final QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .get();

      double totalIncome = 0;
      double totalExpense = 0;

      for (final cardDoc in cardsSnapshot.docs) {
        final QuerySnapshot transactionsSnapshot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(userId)
            .collection('cards')
            .doc(cardDoc.id)
            .collection('transactions')
            .get();

        for (final transactionDoc in transactionsSnapshot.docs) {
          final transactionData = transactionDoc.data() as Map<String, dynamic>;
          final typeTransaction = transactionData['typeTransaction'] as String;
          final amount = transactionData['price'] as double;

          if (typeTransaction == '+') {
            totalIncome += amount;
          } else if (typeTransaction == '-') {
            totalExpense += amount;
          }
        }
      }

      setState(() {
        totalIncomeTransaction = totalIncome;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchTransactionIncome() async {
    try {
      final String userId = widget.user.uid; // ID del usuario actual
      final QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .get();

      double totalIncome = 0;
      double totalExpense = 0;

      for (final cardDoc in cardsSnapshot.docs) {
        final QuerySnapshot transactionsSnapshot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(userId)
            .collection('cards')
            .doc(cardDoc.id)
            .collection('transactions')
            .get();

        for (final transactionDoc in transactionsSnapshot.docs) {
          final transactionData = transactionDoc.data() as Map<String, dynamic>;
          final typeTransaction = transactionData['typeTransaction'] as String;
          final amount = transactionData['price'] as double;

          if (typeTransaction == '+') {
            totalIncome += amount;
          } else if (typeTransaction == '-') {
            totalExpense += amount;
          }
        }
      }
      setState(() {
        totalIncomeTransaction = 200000;

        print(totalIncome.toInt());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(userId: widget.user.uid),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 20,
          top: 70,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Resumen",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "Cuentas",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          // Cards
          Row(
            children: [
              FutureBuilder<void>(
                future: fetchTotalBudgetsFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de carga mientras se obtienen los datos
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Muestra un mensaje de error si ocurre algún problema
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Los datos se han obtenido correctamente, puedes mostrar los widgets dependientes de totalBudgets
                    return Row(
                      children: [
                        Row(
                          children: <Widget>[
                            colorCard(
                              "Ahorros",
                              totalBudgets,
                              1,
                              context,
                              Color(0xFF1b5bff),
                            )
                          ],
                        ),
                        // ...
                      ],
                    );
                  }
                },
              ),
              Row(
                children: <Widget>[
                  colorCard(
                    "Tarjetas registradas",
                    totalCreditCardsBalance,
                    1,
                    context,
                    Color.fromARGB(255, 243, 17, 17),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Ahorros",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
                TextSpan(
                  text: "    Julio",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(
              top: 15,
              right: 20,
            ),
            padding: EdgeInsets.all(10),
            height: screenAwareSize(150, context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  spreadRadius: 10,
                )
              ],
            ),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budgetData = (budgets[index]?.data() ?? {})
                    as Map<String, dynamic>; // Realizar conversión de tipo
                final nameBudget = budgetData['nameBudget'] ?? 0.0;
                final percentBudget = budgetData['porcentBudget'] ?? 0.0;

                return Column(
                  children: [
                    Text(
                      "Ahorro ${nameBudget}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    LinearPercentIndicator(
                      width: screenAwareSize(
                        _media.width - (_media.longestSide <= 775 ? 100 : 160),
                        context,
                      ),
                      lineHeight: 20.0,
                      percent: percentBudget / 100,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Color(0xFF1b52ff),
                      animation: true,
                      animateFromLastPercent: true,
                      alignment: MainAxisAlignment.spaceEvenly,
                      animationDuration: 1000,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      leading: Text(""),
                      trailing: Text(""),
                      center: Text(
                        "${(percentBudget).toStringAsFixed(1)}%",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Flujo de dinero",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          vaweCard(
            context,
            "Entradas",
            totalIncomeTransaction,
            1,
            Colors.grey.shade100,
            Color(0xFF716cff),
          ),

          vaweCard(
            context,
            "Gastos",
            totalExpenseTransaction,
            -1,
            Colors.grey.shade100,
            Color(0xFFff596b),
          ),
        ],
      ),
    );
  }

  Widget vaweCard(BuildContext context, String name, double amount, int type,
      Color fillColor, Color bgColor) {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        right: 20,
      ),
      padding: EdgeInsets.only(left: 15),
      height: screenAwareSize(80, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            spreadRadius: 10,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              WaveProgress(
                screenAwareSize(45, context),
                fillColor,
                bgColor,
                67,
              ),
              Text(
                "80%",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${type > 0 ? "" : "-"} \$ ${amount.toString()}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget donutCard(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 0,
            top: 18,
            right: 10,
          ),
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            inherit: true,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ],
    );
  }

  Widget colorCard(
      String text, double amount, int type, BuildContext context, Color color) {
    final _media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 15, right: 15),
      padding: EdgeInsets.all(15),
      height: screenAwareSize(90, context),
      width: _media.width / 2 - 25,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 0.2,
                offset: Offset(0, 8)),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${type > 0 ? "" : "-"} \$ ${amount.toString()}",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
