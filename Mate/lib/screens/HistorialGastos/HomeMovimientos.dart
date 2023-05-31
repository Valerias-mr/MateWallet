import 'package:bankingapp/screens/login/cardRegistration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenMovimientos extends StatelessWidget {
  const HomeScreenMovimientos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: BodyMovements(),
      appBar: buildAppBar(),
    );
  }

  AppBar buildAppBar() {
    final user = FirebaseAuth.instance.currentUser!;
    final userId = user.uid;

    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      centerTitle: false,
      title: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final userName = snapshot.data!['name'];
            final firstName =
                userName.split(' ')[0]; // Obtener el primer nombre

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage("assets/images/walmart.png"),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  SizedBox(width: 10),
                  Text(
                    firstName,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CardRegistration()),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
