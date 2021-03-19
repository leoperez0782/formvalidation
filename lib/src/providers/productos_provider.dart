import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formvalidation/url_constants.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class ProductosProvider {
  final String _url = dbUrl;

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';
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
}
