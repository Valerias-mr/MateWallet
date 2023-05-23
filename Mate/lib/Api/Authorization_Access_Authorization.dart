import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> obtenerAccessToken() async {
  final String apiUrl =
      'https://gw-sandbox-qa.apps.ambientesbc.com/public-partner/sb/security/oauth-provider/oauth2/token'; // Reemplaza con la URL de tu API

  // Datos necesarios en el body del POST
  Map<String, String> Body = {
    'grant_type': 'client_credentials',
    'scope':
        'Customer-viability:read:app Customer-token:write:user Validate-otp:read:user TermsConditions:read:user TermsConditions-register:write:user Products-payment:read:user BancolombiaPay-wallet:write:user Product-balance:read:user Payment:write:user VoidTransfer-payment:write:user SecurityCode:read:app SecurityCode:write:app Qr-transaction:write:user Qr:read:app',
    'client_id': 'd0f3037b2783e1f38b822365368985fd',
    'client_secret': 'cda9962310cbbdd10155364b56685884',
  };

  // Headers requeridos
  Map<String, String> Headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

  var response = await http.post(
    Uri.parse(apiUrl),
    body: Body,
    headers: Headers,
  );

  // Comprobar el estado de la respuesta
  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    Map<String, dynamic> data = json.decode(response.body);
    String accessToken = data['access_token'];
    return accessToken;
  } else {
    // En caso de error, imprimir el código de estado y el mensaje de error
    print('Error ${response.statusCode}: ${response.body}');
    return null;
  }
}
