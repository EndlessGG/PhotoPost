import 'package:flutter/material.dart';
import '../canvas/canvas.dart'; // Importar la vista de Canvas

class GridViewS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto "Techo"', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0, // Sin sombra
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Proyecto "Techo"',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Número de columnas en la cuadrícula
                crossAxisSpacing: 10, // Espacio entre columnas
                mainAxisSpacing: 10, // Espacio entre filas
                children: [
                  _buildGridItem(context, 'Imagen1'),
                  _buildGridItem(context, 'Imagen2'),
                  _buildGridItem(context, 'Nombre'),
                  _buildGridItem(context, 'Nombre'),
                  _buildGridItem(context, 'Nombre'),
                  _buildGridItem(context, 'Nombre'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes manejar la acción para tomar una nueva foto
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  // Método para construir cada elemento de la cuadrícula
  Widget _buildGridItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // Navegar a la vista de Canvas al hacer clic en el item
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Canvas()), // Navegar a Canvas
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen ajustada para llenar completamente el contenedor
            Expanded(
              child: Container(
                width: double.infinity, // Para que la imagen llene el ancho
                child: Image.asset(
                  'assets/placeholder_image.png', // Reemplaza con la ruta de tu imagen
                  fit: BoxFit
                      .cover, // Ajuste para que la imagen llene el contenedor
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
