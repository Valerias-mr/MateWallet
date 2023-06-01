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
  TextEditingController _typeTransactionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  String recentTitle = '';
  String recentImage = '';
  String recentDescription = '';
  String recentCategory = '';
  String recenttypeTransaction = '';

  int recentPrice = 0;

  void _createTransaction() {
    final String title = _titleController.text.trim();
    final String image = _imageController.text.trim();
    final String category = _categoryController.text.trim();
    final String typeTransaction = _categoryController.text.trim();
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
        'typeTransaction': typeTransaction,
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
          recenttypeTransaction = typeTransaction;
        });

        _titleController.clear();
        _imageController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _categoryController.clear();

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
    'Salud',
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
      physics: AlwaysScrollableScrollPhysics(),
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context,
                category); // Pasa la categoría seleccionada al cerrar el modal
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: selectedCategory == category
                  ? Colors.blue
                  : Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  getIconForCategory(category),
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                ),
                SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectCategory() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return _buildCategoryGrid();
      },
    );

    if (selected != null) {
      setState(() {
        selectedCategory = selected;
        _categoryController.text = selected;
      });
    }
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'Hogar':
        return Icons.home;
      case 'Transporte':
        return Icons.directions_car;
      case 'Alimentación':
        return Icons.restaurant;
      case 'Moda':
        return Icons.shopping_bag;
      case 'Salud':
        return Icons.favorite;
      case 'Entretenimiento':
        return Icons.movie;
      case 'Mascotas':
        return Icons.pets;
      case 'Viajes':
        return Icons.flight;
      case 'Tecnología':
        return Icons.devices;
      case 'Educación':
        return Icons.school;
      case 'Impuestos':
        return Icons.attach_money;
      case 'Seguros':
        return Icons.security;
      case 'Compromisos bancarios':
        return Icons.account_balance;
      case 'Mi negocio':
        return Icons.business;
      case 'Otros':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  Widget _buildImageGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context,
                category); // Pasa la categoría seleccionada al cerrar el modal
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: selectedCategory == category
                  ? Colors.blue
                  : Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  getIconForCategory(category),
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                ),
                SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectImage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return _buildCategoryGrid();
      },
    );

    if (selected != null) {
      setState(() {
        selectedCategory = selected;
        _categoryController.text = selected;
      });
    }
  }

  IconData getImageForCategory(String category) {
    switch (category) {
      case 'Hogar':
        return Icons.home;
      case 'Transporte':
        return Icons.directions_car;
      case 'Alimentación':
        return Icons.restaurant;
      case 'Moda':
        return Icons.shopping_bag;
      case 'Salud':
        return Icons.favorite;
      case 'Entretenimiento':
        return Icons.movie;
      case 'Mascotas':
        return Icons.pets;
      case 'Viajes':
        return Icons.flight;
      case 'Tecnología':
        return Icons.devices;
      case 'Educación':
        return Icons.school;
      case 'Impuestos':
        return Icons.attach_money;
      case 'Seguros':
        return Icons.security;
      case 'Compromisos bancarios':
        return Icons.account_balance;
      case 'Mi negocio':
        return Icons.business;
      case 'Otros':
        return Icons.category;
      default:
        return Icons.category;
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
                  category: recentCategory,
                  price: recentPrice,
                  typeTransaction: recenttypeTransaction),
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
                  GestureDetector(
                    onTap: () {
                      _selectImage(); // Llama al método para mostrar el modal y seleccionar una categoría
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _imageController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintText: 'Imagen',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectCategory(); // Llama al método para mostrar el modal y seleccionar una categoría
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
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleButtons(
                        isSelected: [
                          true,
                          false
                        ], // Estado inicial de los botones
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: Colors.blue,
                        onPressed: (index) {
                          setState(() {
                            // Lógica para manejar el cambio de estado de los botones
                            // Puedes almacenar el estado seleccionado en una variable y utilizarlo según sea necesario
                          });
                        },
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text(
                              'Ingreso',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text(
                              'Salida',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
