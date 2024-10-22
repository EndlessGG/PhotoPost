import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/project_controller.dart'; // Import the ProjectController
import '../project_view/project_view.dart'; // Import your ProjectView
import '../new_project/new_project.dart'; // Import your NewProjectView

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('¡Hola, (nombre)!'),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Acción para el perfil de usuario
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menú',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: Text('Opción 1'), onTap: () {}),
            ListTile(title: Text('Opción 2'), onTap: () {}),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProjectController>(
          // Listening to ProjectController changes
          builder: (context, controller, child) {
            return ListView.builder(
              itemCount: controller.projects.length,
              itemBuilder: (context, index) {
                final project = controller.projects[index];
                return _buildProjectCard(
                    context, project.name, project.id); // Pass project id
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              maxChildSize: 1.0,
              builder: (_, controller) =>
                  NewProjectView(), // NewProjectView allows creating new projects
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectCard(
      BuildContext context, String projectName, String projectId) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          // Navigate to ProjectView, passing the selected project's ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectView(
                  projectId: projectId), // Pass projectId to ProjectView
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey[500]),
                ),
              ),
              SizedBox(height: 10),
              Text(
                projectName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
