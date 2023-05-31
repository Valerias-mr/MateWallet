import 'package:bankingapp/screens/HistorialGastos/components/CreateTransactionComponents/transactions.dart';
import 'package:bankingapp/screens/HistorialGastos/components/TransactionsComponents/components/transactions.dart';
import 'package:bankingapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionCreate extends StatefulWidget {
  final String userId;
  final String cardId;

  const TransactionCreate(
      {Key? key, required this.userId, required this.cardId})
      : super(key: key);

  @override
  _TransactionCreateState createState() => _TransactionCreateState();
}

class _TransactionCreateState extends State<TransactionCreate> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  String recentTitle = '';
  String recentImage = '';
  String recentDescription = '';
  int recentPrice = 0;

  void _createTransaction() {
    final String title = _titleController.text.trim();
    final String image = _imageController.text.trim();
    final String description = _descriptionController.text.trim();
    final int price = int.tryParse(_priceController.text.trim()) ?? 0;

    if (title.isNotEmpty &&
        image.isNotEmpty &&
        description.isNotEmpty &&
        price > 0) {
      final transactionData = {
        'title': title,
        'image': image,
        'description': description,
        'price': price,
      };

      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('cards')
          .doc(widget.cardId)
          .collection('transactions')
          .add(transactionData)
          .then((value) {
        setState(() {
          recentTitle = title;
          recentImage = image;
          recentDescription = description;
          recentPrice = price;
        });

        _titleController.clear();
        _imageController.clear();
        _descriptionController.clear();
        _priceController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transacción creada exitosamente.'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la transacción.'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos correctamente.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(userId: widget.userId),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: RecentTransactionsCardCreate(
                title: recentTitle,
                image: recentImage,
                description: recentDescription,
                price: recentPrice,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        recentTitle = value.trim();
                      });
                    },
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Título'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        recentImage = value.trim();
                      });
                    },
                    controller: _imageController,
                    decoration: InputDecoration(labelText: 'Imagen'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        recentDescription = value.trim();
                      });
                    },
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        recentPrice = int.tryParse(value.trim()) ?? 0;
                      });
                    },
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: _createTransaction,
                    child: Text('Crear transacción'),
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
