import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/getcel.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';
  late String _verificationId;

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void verify() async {
    setState(() {
      _isLoading = true;
    });

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isVerified = true;
        _isLoading = false;
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      setState(() {
        _isLoading = false;
      });
      print('Verification failed: $e');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int? resendToken) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };
    String? phoneNumber = await fetchUserPhoneNumber();
    if (phoneNumber != null) {
      print('Número de teléfono del usuario: $phoneNumber');
    } else {
      print('No se encontró el número de teléfono del usuario.');
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
            phoneNumber, 
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Phone number verification failed: $e');
    }
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex == 3) _currentIndex = 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 400,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Lottie.network(
                        'https://assets2.lottiefiles.com/packages/lf20_zrqthn6o.json',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Verificación de Identidad",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                "Por favor ingresa el código enviado a tu celular",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 15),
              VerificationCode(
                length: 6,
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                underlineColor: Colors.black,
                keyboardType: TextInputType.number,
                underlineUnfocusedColor: Colors.black,
                onCompleted: (value) {
                  setState(() {
                    _code = value;
                  });
                },
                onEditing: (value) {},
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No recibiste tu código OTP?",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isResendAgain) return;
                      resend();
                    },
                    child: Text(
                      _isResendAgain
                          ? "Intentar de nuevo " + _start.toString()
                          : "Reenviar",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              MaterialButton(
                elevation: 0,
                onPressed: _code.length < 4
                    ? () => {}
                    : () {
                        verify();
                      },
                color: Colors.orange.shade400,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: _isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                          color: Colors.black,
                        ),
                      )
                    : _isVerified
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 30,
                          )
                        : Text(
                            "Verificar",
                            style: TextStyle(color: Colors.white),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
