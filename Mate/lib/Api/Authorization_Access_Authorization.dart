import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> obtenerAccessToken() async {
  final String apiUrl =
      'https://gw-sandbox-qa.apps.ambientesbc.com/public-partner/sb/security/oauth-provider/oauth2/token';

  Map<String, String> body = {
    'grant_type': 'client_credentials',
    'scope':
        'Customer-viability:read:app Customer-token:write:user Validate-otp:read:user TermsConditions:read:user TermsConditions-register:write:user Products-payment:read:user BancolombiaPay-wallet:write:user Product-balance:read:user Payment:write:user VoidTransfer-payment:write:user SecurityCode:read:app SecurityCode:write:app Qr-transaction:write:user Qr:read:app',
    'client_id': 'd0f3037b2783e1f38b822365368985fd',
    'client_secret': 'cda9962310cbbdd10155364b56685884',
  };

  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'Host': 'gw-sandbox-qa.apps.ambientesbc.com',
    'X-Forwarded-Host':
        'gw-sandbox-qa.apps.ambientesbc.com', // Agrega el valor correcto del Host
  };

  String basicAuth = base64Encode(
      utf8.encode('${body['client_id']}:${body['client_secret']}'));
  headers['Authorization'] = 'Basic $basicAuth';

  var response =
      await http.post(Uri.parse(apiUrl), body: body, headers: headers);

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    String accessToken = data['access_token'];
    return accessToken;
  } else {
    print('Error ${response.statusCode}: ${response.body}');
    return "Error";
  }
}
