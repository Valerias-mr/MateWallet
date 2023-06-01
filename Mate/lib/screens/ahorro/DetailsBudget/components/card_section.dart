import 'package:bankingapp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardSectionBudget extends StatefulWidget {
  const CardSectionBudget({Key? key}) : super(key: key);

  @override
  _CardSectionBudgetState createState() => _CardSectionBudgetState();
}

class _CardSectionBudgetState extends State<CardSectionBudget> {
  String? selectedCardId;
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _budgetController = TextEditingController();

  void _saveBudget() {
    if (selectedCardId != null) {
      final int priceBudgetAbono = int.parse(_budgetController.text.trim());
      double percentBudget = 0.0;
      String labelPercentage = '';

      // Obtener el valor actual de priceBudget en Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('budgets')
          .doc(selectedCardId)
          .get()
          .then((snapshot) {
        final int currentValue = snapshot.data()?['porcentBudget'] ?? 0;
        final int priceBudget = snapshot.data()?['priceBudget'] ?? 0;
        final int nameBudget = snapshot.data()?['nameBudget'] ?? 0;

        // Calcular nuevos valores
        percentBudget += (priceBudgetAbono * 100) / priceBudget;
        labelPercentage = '$percentBudget%';

        // Actualizar los valores en Firebase
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('budgets')
            .doc(selectedCardId)
            .update({
          'percentBudget': percentBudget,
          'label_percentage': labelPercentage
        }).then((value) {
          print('Budget updated successfully');
        }).catchError((error) {
          print('Failed to update budget: $error');
        });

        // Crear una nueva transacción en la tarjeta seleccionada
        final DateTime now = DateTime.now();
        final String formattedDate =
            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cards')
            .doc(selectedCardId)
            .collection('transactions')
            .add({
          'category': "percentBudget",
          'description': "Ahorro a $nameBudget",
          'price': priceBudget,
          'title': "Ahorro a $nameBudget",
          'typeTransaction': "-",
        }).then((value) {
          print('Transaction created successfully');
        }).catchError((error) {
          print('Failed to create transaction: $error');
        });

        // Navegar de regreso a la pantalla de inicio
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _saveBudgetButton = StreamBuilder<bool>(
      builder: (context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width - 40,
          child: ElevatedButton(
            child: Text(
              'Guardar Ahorro',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              onPrimary: Colors.white,
            ),
            onPressed: _saveBudget,
          ),
        );
      },
    );

    final _budgetField = StreamBuilder(builder: (context, snapshot) {
      return TextField(
        controller: _budgetController,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Ingresa el valor a ahorrar',
        ),
      );
    });

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
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

                    return Row(
                      children: cards.map((document) {
                        final cardId = document.id;

                        return Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCardId = document.id;
                              });
                            },
                            child: CardComponentBudget(
                              document: document,
                              isSelected: selectedCardId == document.id,
                              onCardSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedCardId = document.id;
                                  } else {
                                    selectedCardId = null;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                _budgetField,
                SizedBox(height: 15),
                _saveBudgetButton
              ],
            ),
          ),
        )
      ],
    );
  }
}
