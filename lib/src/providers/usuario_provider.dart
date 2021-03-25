import 'dart:convert';

import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:formvalidation/url_constants.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$fireBaseToken';

  final String _loginUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$fireBaseToken';
  final _prefs = PreferenciasUsuario();
  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    return _processResponse(email, password, _signInUrl);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return _processResponse(email, password, _loginUrl);
  }

  Future<Map<String, dynamic>> _processResponse(
      String email, String password, String url) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(url, body: json.encode(authData));
    print(resp.body);
    final Map<String, dynamic> decodeResponse = json.decode(resp.body);
    print(decodeResponse);

    if (decodeResponse.containsKey('idToken')) {
      _prefs.token = decodeResponse['idToken'];
      return {'ok': true, 'token': decodeResponse['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResponse['error']['message']};
    }
  }
}
