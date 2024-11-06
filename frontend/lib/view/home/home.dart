import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/project_controller.dart';
import '../../model/project_model.dart';
import '../project_view/project_view.dart';
import '../new_project/new_project.dart';

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
            ListTile(
              title: Text('Aviso de Privacidad'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Aviso de Privacidad'),
                      content: SingleChildScrollView(
                        child: Text(
                          '''Fecha de última actualización: 22 de octubre de 2024.

La aplicación PhotoPost respeta su privacidad y está comprometida con la protección de los datos personales que usted nos proporciona.

Los datos personales que recabamos a través de la Aplicación serán utilizados para las siguientes finalidades:
- Crear y gestionar proyectos en la Aplicación.
- Registrar y autenticar usuarios para garantizar el acceso adecuado a sus proyectos.
- Permitir la colaboración y el intercambio de datos, como imágenes, entre los usuarios de un mismo proyecto.

Para más información, consulte el aviso de privacidad completo.''',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cerrar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProjectController>(
          builder: (context, controller, child) {
            return ListView.builder(
              itemCount: controller.projects.length,
              itemBuilder: (context, index) {
                final project = controller.projects[index];
                return _buildProjectCard(
                    context, project); // Passing project directly
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
              builder: (_, controller) => NewProjectView(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectView(projectId: project.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              project.imagePath != null
                  ? Image.network(
                      project.imagePath!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image,
                            size: 50, color: Colors.grey[500]),
                      ),
                    ),
              SizedBox(height: 10),
              Text(
                project.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Creado el: ${project.creationDate.toLocal().toIso8601String().split('T')[0]}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
              'Habitaciones: ${project.rooms.length}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.blue),
                  onPressed: () {
                    // Acción para compartir el proyecto
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    final controller =
                        Provider.of<ProjectController>(context, listen: false);
                    controller.projects.removeWhere((p) => p.id == project.id);
                    controller.notifyListeners();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
