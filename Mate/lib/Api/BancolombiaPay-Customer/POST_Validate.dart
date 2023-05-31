import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<dynamic> validateCustomer(String bearerToken) async {
  final String apiUrl =
      'https://gw-sandbox-qa.apps.ambientesbc.com/public-partner/sb/v1/operations/cross-product/payments/bancolombiapay/validate'; // Reemplaza con la URL de tu API

  // Obtener el usuario actualmente logeado
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Obtener los datos del usuario desde Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userSnapshot.exists) {
      String identificationType = userSnapshot.get('typeId');
      String identificationNumber = userSnapshot.get('documentNumber');

      // Datos necesarios en el body del POST
      Map<String, dynamic> body = {
        'data': {
          'customer': {
            'identification': {
              'type': identificationType,
              'number': identificationNumber,
            }
          }
        }
      };

      // Headers requeridos
      Map<String, String> headers = {
        'Content-Type': 'application/vnd.bancolombia.v4+json',
        'Accept': 'application/vnd.bancolombia.v4+json',
        'Authorization': 'Bearer $bearerToken',
        'messageid': 'c4e6bd04-5149-11e7-b114-b2f933d5fe66',
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: headers,
      );

      // Comprobar el estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['data'];

        if (data.containsKey('security')) {
          Map<String, dynamic> securityData = data['security'];
          String enrollmentKey = securityData['enrollmentKey'];
          String urlAuthenticate = securityData['urlAuthenticate'];

          // Realizar acciones con los datos obtenidos
          print('Enrollment Key: $enrollmentKey');
          print('URL de autenticación: $urlAuthenticate');
        } else {
          // La respuesta no contiene los datos esperados
          print('La respuesta no contiene los datos de seguridad');
        }
      } else {
        // En caso de error, imprimir el código de estado y el mensaje de error
        print('Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } else {
      print('No se encontró el documento del usuario en Firestore');
      return null;
    }
  } else {
    print('No hay usuario logeado');
    return null;
  }
}
