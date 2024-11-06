import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/project_controller.dart'; // Import the controller

class NewProjectView extends StatefulWidget {
  @override
  _NewProjectViewState createState() => _NewProjectViewState();
}

class _NewProjectViewState extends State<NewProjectView> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath; // This would be set when selecting an image

  @override
  void dispose() {
    _nameController.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Padding(
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
                controller: _nameController, // Controller for project name
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
                      setState(() {
                        // Simulate image selection
                        _imagePath = 'path_to_image'; // Placeholder for image path
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Create button
              ElevatedButton(
                onPressed: () {
                  final projectName = _nameController.text;
                  if (projectName.isNotEmpty) {
                    // Access the ProjectController and add the project
                    Provider.of<ProjectController>(context, listen: false)
                        .addProject(projectName, _imagePath);
                    Navigator.pop(context); // Close the screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('El nombre del proyecto es obligatorio')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black), // Add a border
                  ),
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
      ),
    );
  }
}
