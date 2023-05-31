import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/appbar.dart';
import 'cardcomponentR.dart';

class CardRegistration extends StatefulWidget {
  const CardRegistration({Key? key}) : super(key: key);

  @override
  _CardRegistrationState createState() => _CardRegistrationState();
}

class _CardRegistrationState extends State<CardRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  Color _cardColor = Colors.blue;
  String _cardNumber = '';
  String _expiryDate = '';
  String _balance = '';

  bool _isCardNumberValid = true;
  bool _isExpiryDateValid = true;
  bool _isCardUnique = true;

  void _registerCard() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cardNumber = _cardNumberController.text;
        _expiryDate = _expiryDateController.text;
        _balance = _balanceController.text;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        final cardsCollectionRef = userDocRef.collection('cards');

        // Verificar si la tarjeta ya existe
        final querySnapshot = await cardsCollectionRef
            .where('cardNumber', isEqualTo: _cardNumber)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // La tarjeta ya existe
          setState(() {
            _isCardUnique = false;
          });
        } else {
          // La tarjeta es única, registrarla
          final newCardDocRef = await cardsCollectionRef.add({
            'cardNumber': _cardNumber,
            'expiryDate': _expiryDate,
            'balance': _balance,
          });

          // Reiniciar los campos del formulario
          _cardNumberController.clear();
          _expiryDateController.clear();
          _balanceController.clear();

          // Borrar los campos del componente Card
          setState(() {
            _cardNumber = '';
            _expiryDate = '';
            _balance = '';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tarjeta registrada exitosamente')),
          );
        }
      }
    }
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el número de tarjeta';
    } else if (!_isNumeric(value)) {
      return 'El número de tarjeta solo puede contener números';
    } else if (value.length != 16) {
      return 'El número de tarjeta debe tener 16 dígitos';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa la fecha de expiración';
    } else if (!_isExpiryDateFormatValid(value)) {
      return 'El formato de fecha de expiración debe ser MM/YY';
    }

    final parts = value.split('/');
    final expiryMonth = int.tryParse(parts[0]) ?? 0;

    if (expiryMonth <= 0 || expiryMonth > 12) {
      return 'El mes de expiración no es válido';
    }

    if (_isExpiryDateExpired(value)) {
      return 'La tarjeta ha vencido o está a punto de vencer';
    }

    return null;
  }

  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  bool _isExpiryDateFormatValid(String value) {
    final datePattern = r'^\d{2}/\d{2}$';
    final regExp = RegExp(datePattern);
    return regExp.hasMatch(value);
  }

  bool _isExpiryDateExpired(String value) {
    final currentDate = DateTime.now();
    final parts = value.split('/');
    final expiryMonth = int.tryParse(parts[0]) ?? 0;
    final expiryYear = int.tryParse(parts[1]) ?? 0;
    final expiryDate = DateTime(2000 + expiryYear, expiryMonth + 1, 0);
    return expiryDate.isBefore(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: MyAppBar(userId: user!.uid),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardComponent(
              color: _cardColor,
              cardNumber: _cardNumber,
              expiryDate: _expiryDate,
              balance: _balance,
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Número de tarjeta',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                    validator: _validateCardNumber,
                    onChanged: (value) {
                      setState(() {
                        _isCardNumberValid = true;
                        _cardNumber = value;
                      });
                    },
                  ),
                  if (!_isCardNumberValid)
                    Text(
                      'El número de tarjeta no es válido',
                      style: TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'MM/YY',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                    ),
                    validator: _validateExpiryDate,
                    onChanged: (value) {
                      setState(() {
                        _isExpiryDateValid = true;
                        _expiryDate = value;
                      });
                    },
                  ),
                  if (!_isExpiryDateValid)
                    Text(
                      'La fecha de expiración no es válida',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (!_isCardUnique)
                    Text(
                      'Esta tarjeta ya ha sido registrada',
                      style: TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                    controller: _balanceController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Saldo',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingresa el saldo';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _balance = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _registerCard,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width / 1.12, 55),
                    ),
                    child: Text('Registrar Tarjeta'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
