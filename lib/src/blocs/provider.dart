import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/login_bloc.dart';
export 'package:formvalidation/src/blocs/login_bloc.dart';

///Implemenación de InheritedWidget.
///Va a ser la raiz de la aplicación.
///Se usa para manejar el estado de la app.
class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();

  Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext contex) {
    return contex.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
