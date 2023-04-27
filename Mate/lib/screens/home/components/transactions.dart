import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 3 * (59 + 10),
              child: ListView(
                children: [
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecentTransaction extends StatelessWidget {
  const RecentTransaction(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.price});

  final String image, title, description;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: AssetImage(image),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text(
                    "$description",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text("- \$$price",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
