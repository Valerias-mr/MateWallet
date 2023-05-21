import 'dart:async';

import 'package:bankingapp/controllers/utils.dart';
import 'package:bankingapp/main.dart';
import 'package:bankingapp/screens/home/home_screen.dart';
import 'package:bankingapp/screens/login/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankingapp/animation/FadeAnimation.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _typeIdController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _typeIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            "Crear una cuenta",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.2,
                          makeInput(
                              label: "Nombre", controller: _nameController)),
                      FadeAnimation(
                          1.2,
                          makeEmailInput(
                              label: "Correo electronico",
                              controller: _emailController)),
                      FadeAnimation(
                          1.2,
                          makeSelectorInput(
                              label: "Tipo de Documento",
                              controller: _typeIdController)),
                      FadeAnimation(
                          1.2,
                          makeInput(
                              label: "Número de documento",
                              controller: _idController)),
                      FadeAnimation(
                          1.3,
                          makepasswordInput(
                            label: "Contraseña",
                            controller: _passwordController,
                            obscureText: true,
                          )),
                      FadeAnimation(
                          1.4,
                          makepasswordInput(
                              label: "Confirmar Contraseña",
                              obscureText: true)),
                    ],
                  ),
                  FadeAnimation(
                      1.5,
                      Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: signUp,
                          color: Colors.greenAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Registrar cuenta",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      )),
                  FadeAnimation(
                      1.6,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("¿Ya tienes una cuenta?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              " Inicia sesión",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Obtener el ID único del usuario
      final userId = userCredential.user!.uid;

      // Guardar los datos adicionales en Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text.trim(),
        'typeId': _typeIdController.text.trim(),
        'documentNumber': _idController.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Widget makeInput({label, entrada, obscureText = false, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget makeSelectorInput({label, entrada, obscureText = false, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        DropdownButtonFormField<String>(
          value: entrada,
          onChanged: (value) {
            // Actualizar el valor seleccionado
            controller.text = value;
          },
          items: [
            DropdownMenuItem<String>(
              value: 'C.C',
              child: Text('C.C'),
            ),
            DropdownMenuItem<String>(
              value: 'C.E',
              child: Text('C.E'),
            ),
            DropdownMenuItem<String>(
              value: 'NIT',
              child: Text('NIT'),
            ),
            DropdownMenuItem<String>(
              value: 'T.I',
              child: Text('T.I'),
            ),
            DropdownMenuItem<String>(
              value: 'PAS',
              child: Text('PAS'),
            ),
            DropdownMenuItem<String>(
              value: 'IEPN',
              child: Text('IEPN'),
            ),
            DropdownMenuItem<String>(
              value: 'IEPJ',
              child: Text('IEPJ'),
            ),
            DropdownMenuItem<String>(
              value: 'FD',
              child: Text('FD'),
            ),
            DropdownMenuItem<String>(
              value: 'RC',
              child: Text('RC'),
            ),
          ],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget makeEmailInput({label, entrada, obscureText = false, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) => email != null && !EmailValidator.validate(email)
              ? "Ingresa un correo valido"
              : null,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget makepasswordInput({label, entrada, obscureText = false, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value != null && value.length < 6
              ? "Ingresa mínimo 6 caracteres"
              : null,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
