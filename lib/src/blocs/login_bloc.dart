import 'dart:async';

import 'package:formvalidation/src/blocs/validators.dart';

class LoginBloc with Validators {
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  //Recuperar los datos del stream.
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  //Insertar valores al stream.
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePasword => _passwordController.sink.add;

  dispose() {
    // ignore: unnecessary_statements
    _emailController?.close;
    // ignore: unnecessary_statements
    _passwordController?.close;
  }
}
