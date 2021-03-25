import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:formvalidation/url_constants.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class ProductosProvider {
  final String _url = dbUrl;
  final _prefs = PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    print('url: $url');

    final resp = await http.post(url, body: productoModelToJson(producto));

    // if (resp.statusCode == 200) {
    //   print('funciona');
    // } else {
    //   print('no funciona');
    // }
    print(productoModelToJson(producto));
    //print('La respuesta es: $resp');
    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = List();
    if (decodedData == null) return [];

    if (decodedData['error'] != null) {
      throw (decodedData['error']);
    }
    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    print(resp.body);
    return 1;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    print('url: $url');

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dkfdfq4vh/image/upload?upload_preset=yjpwdyy4');

    final mimeType = mime(imagen.path).split('/'); //image/jpeg
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
        'file', //Nombre del campo
        imagen.path, //camino al archivo.
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file); //subo archivo

    final streamReasponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamReasponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Error al subir archivo');
      print(resp.body);
      return null;
    }

    final responseData = json.decode(resp.body);
    print(responseData);

    return responseData['secure_url'];
  }
}
