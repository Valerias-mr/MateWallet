import 'package:bankingapp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardSectionBudget extends StatefulWidget {
  final String budgetId;

  const CardSectionBudget({Key? key, required this.budgetId}) : super(key: key);

  @override
  _CardSectionBudgetState createState() => _CardSectionBudgetState();
}

class _CardSectionBudgetState extends State<CardSectionBudget> {
  String? selectedCardId;
  final TextEditingController _budgetController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (selectedCardId != null && _budgetController.text.trim().isNotEmpty) {
      final int priceBudgetAbono = int.parse(_budgetController.text.trim());
      String labelPercentage = '';

      final user = FirebaseAuth.instance.currentUser!;

      // Obtener la tarjeta seleccionada
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .doc(selectedCardId)
          .get()
          .then((cardSnapshot) {
        final double balance =
            (cardSnapshot.data()?['balance'] ?? 0).toDouble();

        if (balance >= priceBudgetAbono) {
          // Obtener el valor actual de priceBudget en Firestore
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('budgets')
              .doc(widget.budgetId)
              .get()
              .then((snapshot) {
            final double priceBudget =
                (snapshot.data()?['priceBudget'] ?? 0).toDouble();
            final String nameBudget = snapshot.data()?['nameBudget'] ?? '';
            double percentBudget =
                (snapshot.data()?['porcentBudget'] ?? 0).toDouble();

            // Calcular nuevos valores
            percentBudget =
                percentBudget + (priceBudgetAbono * 100) / priceBudget;
            //label
            labelPercentage = '$percentBudget%';

            if (percentBudget <= 100) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('budgets')
                  .doc(widget.budgetId)
                  .update({
                'porcentBudget': percentBudget,
                'label_percentage': labelPercentage
              }).then((value) {
                print('Budget updated successfully');
              }).catchError((error) {
                print('Failed to update budget: $error');
              });

              // Actualizar el balance de la tarjeta seleccionada
              double newBalance = balance - priceBudgetAbono;
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('cards')
                  .doc(selectedCardId)
                  .update({'balance': newBalance}).then((value) {
                print('Card balance updated successfully');
              }).catchError((error) {
                print('Failed to update card balance: $error');
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
                'category': "Ahorros",
                'description': "Ahorro a $nameBudget",
                'price': priceBudgetAbono.toInt(),
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
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('El valor a ahorrar no debe superar la meta.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
            // Actualizar los valores en Firebase
          });
        } else {
          // El balance de la tarjeta es menor que priceBudgetAbono
          print('El balance de la tarjeta es menor que el precio del abono');
          // Aquí puedes mostrar un mensaje de error o realizar otra acción en caso de que el balance sea insuficiente.
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Debe seleccionar una tarjeta y llenar el campo de valor a ahorrar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

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
                      .doc(user.uid)
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
