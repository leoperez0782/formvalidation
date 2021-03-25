import 'dart:convert';

import 'package:formvalidation/url_constants.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$fireBaseToken';

  final String loginUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$fireBaseToken';
  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    print('Entra');
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(signInUrl, body: json.encode(authData));
    print(resp.body);
    final Map<String, dynamic> decodeResponse = json.decode(resp.body);
    print(decodeResponse);

    if (decodeResponse.containsKey('idToken')) {
      //todo: salvar token en el storage
      return {'ok': true, 'token': decodeResponse['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResponse['error']['message']};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(loginUrl, body: json.encode(authData));
    print(resp.body);
    final Map<String, dynamic> decodeResponse = json.decode(resp.body);
    print(decodeResponse);

    if (decodeResponse.containsKey('idToken')) {
      //todo: salvar token en el storage
      return {'ok': true, 'token': decodeResponse['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResponse['error']['message']};
    }
  }
}
