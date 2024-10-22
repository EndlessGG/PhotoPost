import 'package:flutter/material.dart';
import '../model/project_model.dart'; // Import the updated Project model

class ProjectController extends ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  // Method to add a new project
  void addProject(String name, String? imagePath) {
    final newProject = Project(
      id: DateTime.now().toString(),
      name: name,
      imagePath: imagePath,
      rooms: [], // Initialize with an empty list
    );
    _projects.add(newProject);
    notifyListeners();
  }

  // Method to add a new room to a specific project
void addRoomToProject(String projectId, String roomName) {
    final project = _projects.firstWhere((proj) => proj.id == projectId);
    project.rooms.add(roomName); // Ensure this adds the room
    notifyListeners(); // Notify UI to update
  }


  // Fetch a project by ID
  Project? getProjectById(String projectId) {
    return _projects.firstWhere(
      (proj) => proj.id == projectId,
      orElse: () => throw Exception("Project not found"),
    );
  }
}
