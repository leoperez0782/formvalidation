import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/login_bloc.dart';
export 'package:formvalidation/src/blocs/login_bloc.dart';

///Implemenación de InheritedWidget.
///Va a ser la raiz de la aplicación.
///Se usa para manejar el estado de la app.
class Provider extends InheritedWidget {
  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  final loginBloc = LoginBloc();

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext contex) {
    return contex.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
