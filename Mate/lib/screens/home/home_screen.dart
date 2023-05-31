import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import 'components/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: const [Body()],
      ),
      appBar: MyAppBar(
        userId: user.uid,
        showBackButton: Navigator.canPop(
            context), // Mostrar botón de retroceso solo si es posible volver atrás
      ),
    );
  }
}
