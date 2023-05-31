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
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  String recentTitle = '';
  String recentImage = '';
  String recentDescription = '';
  String recentCategory = '';

  int recentPrice = 0;

  void _createTransaction() {
    final String title = _titleController.text.trim();
    final String image = _imageController.text.trim();
    final String category = _imageController.text.trim();

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
        'category': category,
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
          recentCategory = category;
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

  List<String> categories = [
    'Hogar',
    'Transporte',
    'Alimentación',
    'Moda',
    'Salud y bienestar',
    'Entretenimiento',
    'Mascotas',
    'Viajes',
    'Tecnología',
    'Educación',
    'Impuestos',
    'Seguros',
    'Compromisos bancarios',
    'Mi negocio',
    'Otros',
  ];

  String selectedCategory = '';

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category;
              _categoryController.text = category;
            });
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedCategory == category ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
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
                category: recentCategory,
                price: recentPrice,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        recentTitle = value.trim();
                      });
                    },
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Título',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        recentImage = value.trim();
                      });
                    },
                    controller: _imageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Imagen',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildCategoryGrid(); // Show the category grid in a modal bottom sheet
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintText: 'Categoría',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        recentDescription = value.trim();
                      });
                    },
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Descripción',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        recentPrice =
                            recentPrice = int.tryParse(value.trim()) ?? 0;
                      });
                    },
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Precio',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
