import 'package:bankingapp/json/daily_json.dart';
import 'package:bankingapp/json/day_month.dart';
import 'package:bankingapp/screens/gestion_gastos/edit_gestion.dart';
import 'package:bankingapp/screens/home/home_screen.dart';
import 'package:bankingapp/theme/colors.dart';
import 'package:bankingapp/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 3;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(userId: _auth.currentUser!.uid),
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 20, left: 20, bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gestión de Gastos",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: List.generate(daily.length, (index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: (size.width - 40) * 0.7,
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      daily[index]['icon'],
                                      size: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  width: (size.width - 90) * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        daily[index]['name'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                        ),
                        FutureBuilder<double>(
                          future: getTotalPriceByCategory(daily[index]['name']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              double totalPrice = snapshot.data!;
                              return Container(
                                width: (size.width - 40) * 0.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      totalPrice.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 65, top: 8),
                      child: Divider(
                        thickness: 0.8,
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                FutureBuilder<double>(
                  future: getTotalPriceForAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      double totalPrice = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "\$${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Spacer(),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<double> getTotalPriceByCategory(String category) async {
    double totalPrice = 0;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot cardSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cards')
            .get();

        for (var cardDoc in cardSnapshot.docs) {
          QuerySnapshot transactionSnapshot = await cardDoc.reference
              .collection('transactions')
              .where('category', isEqualTo: category)
              .get();

          for (var transactionDoc in transactionSnapshot.docs) {
            Map<String, dynamic> data =
                transactionDoc.data() as Map<String, dynamic>;
            if (data.containsKey('price')) {
              double price = double.tryParse(data['price'].toString()) ?? 0;
              totalPrice += price;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
    return totalPrice;
  }

  Future<double> getTotalPriceForAllCategories() async {
    double totalPrice = 0;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot cardSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cards')
            .get();

        for (var cardDoc in cardSnapshot.docs) {
          QuerySnapshot transactionSnapshot =
              await cardDoc.reference.collection('transactions').get();

          for (var transactionDoc in transactionSnapshot.docs) {
            Map<String, dynamic> data =
                transactionDoc.data() as Map<String, dynamic>;
            if (data.containsKey('price')) {
              double price = double.tryParse(data['price'].toString()) ?? 0;
              totalPrice += price;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
    return totalPrice;
  }
}
