import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../canvas/canvas.dart'; // Importa la vista Canvas
import '../../controller/project_controller.dart'; // Importa el ProjectController
import '../../model/project_model.dart'; // Importa Room y ImageWithNotes

class GridViewS extends StatelessWidget {
  final String projectId;
  final Room room;

  GridViewS({required this.projectId, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Proyecto "${room.name}"',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Room?>(
        future: Provider.of<ProjectController>(context, listen: false)
            .getRoomByName(projectId, room.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar la habitación'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No se encontró la habitación'));
          }

          final updatedRoom = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Habitación "${room.name}"',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: updatedRoom.images.length,
                    itemBuilder: (context, index) {
                      final imageWithNotes = updatedRoom.images[index];
                      return _buildGridItem(context, imageWithNotes);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmptyImageWithNotes(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, ImageWithNotes imageWithNotes) {
    print("Ruta de la imagen para el elemento de la cuadrícula: ${imageWithNotes.imagePath}");

    return GestureDetector(
      onTap: () {
        // Navegar a la vista Canvas, pasando la imagen y notas
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Canvas(imageWithNotes: imageWithNotes),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                child: (imageWithNotes.imagePath.isNotEmpty &&
                        File(imageWithNotes.imagePath).existsSync())
                    ? Image.file(
                        File(imageWithNotes.imagePath),
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[500],
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Notas: ${imageWithNotes.notes.length}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _addEmptyImageWithNotes(BuildContext context) {
    Provider.of<ProjectController>(context, listen: false)
        .addEmptyImageToRoom(projectId, room.name);
  }
}
