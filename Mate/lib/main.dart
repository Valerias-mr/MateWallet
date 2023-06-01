import 'package:bankingapp/controllers/utils.dart';
import 'package:bankingapp/screens/login/BancolombiaLoginPage.dart';
import 'package:bankingapp/screens/login/Authenticate.dart';
import 'package:bankingapp/screens/login/HomeScreen.dart';
import 'package:bankingapp/screens/login/cardRegistration.dart';
import 'package:bankingapp/screens/login/login.dart';
import 'package:bankingapp/screens/login/onBoardingCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Api/Authorization-AccesAuthorization/Authorization_Access_Authorization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bankingapp/screens/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Api/BancolombiaPay-Customer/POST_Validate.dart';

bool? seenOnboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // show status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);

  // to load onboard shared preferences for the first time
  SharedPreferences prefs = await SharedPreferences.getInstance();
  seenOnboard = prefs.getBool('seenOnboard') ?? false;

  runApp(const MyApp());

  MultiProvider(providers: [
    ChangeNotifierProvider<ValueNotifier<String?>>(
      create: (_) => ValueNotifier<String?>(null),
    )
  ]);
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      theme: ThemeData(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Mate',
      home: seenOnboard == true
          ? StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    // Verificar si el usuario tiene tarjetas registradas
                    if (user != null) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('cards')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            final cards = snapshot.data?.docs;
                            if (cards != null && cards.isNotEmpty) {
                              // El usuario tiene tarjetas registradas, redirígelo al home screen
                              return HomeScreen();
                            } else {
                              // El usuario no tiene tarjetas registradas, redirígelo a la página de registro de tarjeta
                              return onBoardingAddCard();
                            }
                          }
                          // Mientras se carga la consulta a Firestore, puedes mostrar una pantalla de carga o algún indicador de progreso
                          return CircularProgressIndicator();
                        },
                      );
                    }
                  }
                  // Si el usuario no está registrado, redirígelo a la página de inicio de sesión
                  return LoginPage();
                }
                // Mientras se carga la autenticación, puedes mostrar una pantalla de carga o algún indicador de progreso
                return CircularProgressIndicator();
              },
            )
          : const OnboardingPage(),
    );
  }
}
