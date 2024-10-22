import 'package:flutter/material.dart';
import '../new_project/new_project.dart';
import '../project_view/project_view.dart'; // Asegúrate de importar tu archivo de ProjectView

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('¡Hola, (nombre)!'),
            SizedBox(width: 10), // Espacio entre el texto y el icono
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
        // Menú lateral
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {
                // Navegar a otra página
              },
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {
                // Navegar a otra página
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildProjectCard(context, 'Nombre proyecto'),
                  _buildProjectCard(context, 'Nombre proyecto2'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar un nuevo proyecto
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NewProjectView()), // Navegación a NewProjectView
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, String projectName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        // Utilizamos InkWell para agregar la capacidad de hacer clic en la tarjeta
        onTap: () {
          // Navegar a la vista del proyecto
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProjectView()), // Navegación a ProjectView
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
