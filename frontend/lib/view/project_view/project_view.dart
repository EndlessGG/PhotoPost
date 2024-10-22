import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../grid_view/grid_view.dart'; // Import the Canvas view
import '../../controller/project_controller.dart'; // Import the ProjectController

class ProjectView extends StatelessWidget {
  final String projectId;

  ProjectView({required this.projectId});

  @override
  Widget build(BuildContext context) {
    // Fetch the project by ID from the controller
    final project = Provider.of<ProjectController>(context, listen: true)
        .getProjectById(projectId);

    if (project == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Project Not Found'),
        ),
        body: Center(
          child: Text('The requested project could not be found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('PhotoPost: ${project.name}',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0, // No shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Project name
            Text(
              'Proyecto "${project.name}"',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Image placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300], // Placeholder color
              child: Center(
                child: Icon(Icons.image, size: 100, color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 20),
            // List of rooms
            Expanded(
              child: ListView(
                children: project.rooms
                    .map((roomName) => _buildRoomItem(context, roomName))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      // Floating action button to add a new room
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoomDialog(context, projectId);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white, // Set button background color to black
      ),
    );
  }

  // Method to build room items and navigate to GridView
  Widget _buildRoomItem(BuildContext context, String roomName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(roomName, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to GridView when a room is selected
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GridViewS()), // Navigate to GridView
          );
        },
      ),
    );
  }

  // Method to show the dialog for adding a new room
  void _showAddRoomDialog(BuildContext context, String projectId) {
    final TextEditingController _roomController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar nueva habitación'),
          content: TextField(
            controller: _roomController,
            decoration: InputDecoration(hintText: 'Nombre de la habitación'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Agregar'),
              onPressed: () {
                final roomName = _roomController.text;
                if (roomName.isNotEmpty) {
                  // Add the room to the selected project
                  Provider.of<ProjectController>(context, listen: false)
                      .addRoomToProject(projectId, roomName);
                  Navigator.of(context).pop(); // Close dialog after adding
                }
              },
            ),
          ],
        );
      },
    );
  }
}
