import 'package:flutter/material.dart';

class NewProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow under the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          'Nuevo Proyecto',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Project name input field
            Text(
              'Nombre',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            // Image upload section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Imagen de Portada (Opcional)'),
                IconButton(
                  icon: Icon(Icons.folder),
                  onPressed: () {
                    // Handle image selection
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            // Create button
            ElevatedButton(
              onPressed: () {
                // Handle create project action
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.black), // Add a border
                ), // White background for the button
              ),
              child: Text(
                'Crear',
                style: TextStyle(
                  color: Colors.black, // Black text color
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
