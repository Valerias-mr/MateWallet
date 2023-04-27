import 'package:flutter/material.dart';
import 'package:bankingapp/screens/movimientos/components/transactions.dart';

class RecentTransactionSectionM extends StatefulWidget {
  const RecentTransactionSectionM({
    Key? key,
    required this.transactionType,
  }) : super(key: key);
  final String transactionType;

  @override
  State<RecentTransactionSectionM> createState() =>
      _RecentTransactionSectionMState();
}

class _RecentTransactionSectionMState extends State<RecentTransactionSectionM> {
  @override
  Widget build(BuildContext context) {
    List<RecentTransaction> transactionsA = [
      RecentTransaction(
        title: "NetflixA",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
    ];
    List<RecentTransaction> transactionsB = [
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
    ];
    List<RecentTransaction> transactionsC = [
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
      RecentTransaction(
        title: "Netflix",
        image: "assets/images/netflix.png",
        description: "Entretenimiento",
        price: 10,
      ),
    ];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          if (widget.transactionType ==
              "TypeA") // Mostrar el componente TransactionsA solo si la tarjeta es de Tipo A
            Transactions(
              transactions: transactionsA,
            ),
          if (widget.transactionType ==
              "TypeB") // Mostrar el componente TransactionsB solo si la tarjeta es de Tipo B
            Transactions(
              transactions: transactionsB,
            ),
          if (widget.transactionType ==
              "TypeC") // Mostrar el componente TransactionsC solo si la tarjeta es de Tipo C
            Transactions(
              transactions: transactionsC,
            ),
        ],
      ),
    );
  }
}
