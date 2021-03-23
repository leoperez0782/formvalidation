import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel producto = ProductoModel();
  final productoProvider = ProductosProvider();

  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.tryParse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo puede ingresar numeros';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: () => (_guardando) ? null : _submit(),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState
        .save(); //Dispara el save de todos los textFields del form

    setState(() {
      _guardando = true;
    });
    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }
    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    // setState(() {
    //   _guardando = false;
    // });
    mostrarSnackBar('Registro guardado');
    Navigator.pop(context);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void mostrarSnackBar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);

    if (foto != null) {
      //limpieza
    }

    setState(() {});
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      //Todo: devolver imagen url
      return Container();
    } else {
      // return Image(
      //   image: AssetImage(foto?.path ?? 'assets/images/no-image.png'),
      //   height: 300.0,
      //   fit: BoxFit.cover,
      // );
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/images/no-image.png');
    }
  }
}
