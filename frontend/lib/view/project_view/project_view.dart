import 'package:flutter/material.dart';
import '../canvas/canvas.dart'; // Import the Canvas view

class ProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhotoPost', style: TextStyle(color: Colors.black)),
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
              'Proyecto "Central"',
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
                children: [
                  _buildRoomItem(context, 'Techo'),
                  _buildRoomItem(context, 'Sala'),
                  _buildRoomItem(context, 'Jardin'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new room
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }

  // Method to build room items and navigate to Canvas
  Widget _buildRoomItem(BuildContext context, String roomName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(roomName, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to Canvas view when a room is selected
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Canvas()), // Navigate to Canvas
          );
        },
      ),
    );
  }
}
