import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/provider.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'producto')
          .then((value) => setState(() {})),
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) =>
                _crearItem(context, productosBloc, productos[i], productos, i),
          );
        }
        if (snapshot.hasError) {
          mostrarAlerta(context, snapshot.error);
          Navigator.pushReplacementNamed(context, 'login');
          return null;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto, List<ProductoModel> listaProductos, int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        //Todo: borrar item
        productosBloc.borrarProducto(producto.id).then((value) => setState(() {
              listaProductos.removeAt(index);
            }));
      },
      child: Card(
        child: Column(
          children: [
            (producto.fotoUrl == null)
                ? Image(image: AssetImage('assets/images/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(producto.fotoUrl),
                    placeholder: AssetImage(
                      'assets/images/jar-loading.gif',
                    ),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text('${producto.id}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: producto)
                      .then((value) => setState(() {})),
            )
          ],
        ),
      ),
    );
  }
}
