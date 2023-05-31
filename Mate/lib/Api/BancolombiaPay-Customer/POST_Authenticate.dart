import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> authenticate_Customer(String enrollmentKey, String code) async {
  final String apiUrl =
      'https://gw-sandbox-qa.apps.ambientesbc.com/public-partner/sb/v1/operations/cross-product/payments/bancolombiapay/authenticate'; // Reemplaza con la URL de tu API

  // Datos necesarios en el body del POST
  Map<String, dynamic> body = {
    'data': {
      'security': {
        'enrollmentKey': enrollmentKey,
        'code': code,
      },
    },
  };

  // Headers requeridos
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/vnd.bancolombia.v4+json',
    'messageid': 'application/vnd.bancolombia.v4+json',
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
    // Extraer los datos que necesites de la respuesta
    // ...

    // Retornar los datos extraídos o realizar acciones adicionales
    // ...
  } else {
    // En caso de error, imprimir el código de estado y el mensaje de error
    print('Error ${response.statusCode}: ${response.body}');
    return null;
  }
}
