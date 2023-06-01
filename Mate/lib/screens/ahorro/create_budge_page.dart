import 'package:bankingapp/json/create_budget_json.dart';
import 'package:bankingapp/theme/colors.dart';
import 'package:bankingapp/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:lottie/lottie.dart';

class CreatBudgetPage extends StatefulWidget {
  @override
  _CreatBudgetPageState createState() => _CreatBudgetPageState();
}

class _CreatBudgetPageState extends State<CreatBudgetPage> {
  int activeCategory = 0;
  TextEditingController _budgetName =
      TextEditingController(text: "Presupuesto de compras");
  TextEditingController _budgetDescripcion =
      TextEditingController(text: "Marranito de compras");
  TextEditingController _budgetPrice = TextEditingController(text: "\$1500.00");

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
      appBar: MyAppBar(userId: user.uid),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Alcancia Virtual",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, right: 20, left: 50),
            child: Container(
              width: 300,
              alignment: Alignment.center,
              height: 300,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.0),
                    spreadRadius: 10,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_2wkuqm8b.json',
                fit: BoxFit.contain,
                width: 500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nombre de tu alcancia virtual",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xff67727d),
                  ),
                ),
                TextField(
                  controller: _budgetName,
                  cursorColor: black,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Alcancia virtual",
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Agrega una descripción",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xff67727d),
                  ),
                ),
                TextField(
                  controller: _budgetDescripcion,
                  cursorColor: black,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Descripcion",
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (size.width - 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingresa tu meta",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Color(0xff67727d),
                            ),
                          ),
                          TextField(
                            controller: _budgetPrice,
                            cursorColor: black,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Ingresa tu meta",
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap:
                          createBudget, // Llama al método para crear la budget
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void createBudget() {
    final user = FirebaseAuth.instance.currentUser;
    final budgetCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('budgets');

    // Get the values from the text controllers
    String budgetName = _budgetName.text;
    String budgetDescription = _budgetDescripcion.text;
    double budgetPrice = double.tryParse(_budgetPrice.text) ?? 0.0;

    // Create the budget data
    Map<String, dynamic> budgetData = {
      'nameBudget': budgetName,
      'descriptionBudget': budgetDescription,
      'priceBudget': budgetPrice,
      'label_percentage': "0%",
      'porcentBudget': 0,
    };

    // Add the budget to Firestore
    budgetCollection.add(budgetData).then((value) {
      // Show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Budget created successfully!')),
      );
    }).catchError((error) {
      print('Failed to create budget: $error');
    });
  }
}
