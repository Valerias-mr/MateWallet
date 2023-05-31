import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final bool showBackButton;

  const MyAppBar({
    Key? key,
    required this.userId,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userId = user.uid;

    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading:
          showBackButton, // Mostrar botón de retroceso solo si showBackButton es true
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black, // Color del botón de retroceso
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
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
          child: GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
