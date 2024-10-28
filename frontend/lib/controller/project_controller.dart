import 'package:flutter/material.dart';
import '../model/project_model.dart'; // Importing the model classes

class ProjectController extends ChangeNotifier {
  List<Project> _projects = [];

  // Getter to retrieve the list of projects
  List<Project> get projects => _projects;

  // Method to add a new project
  void addProject(String name, String? imagePath) {
    final newProject = Project(
      id: DateTime.now().toString(), // Unique ID based on current timestamp
      name: name,
      imagePath: imagePath,
      rooms: [], // Initializes with an empty list of rooms
    );
    _projects.add(newProject); // Adds the new project to the list
    notifyListeners(); // Notifies listeners (e.g., UI) to refresh
  }

  // Method to add a room to a specific project
  void addRoomToProject(String projectId, String roomName) {
    final project = getProjectById(projectId);
    if (project != null) {
      // Only adds the room if the project exists
      project.rooms.add(Room(name: roomName, images: []));
      notifyListeners();
    }
  }

  // Method to add an image with notes to a specific room in a project
  void addImageToRoom(
      String projectId, String roomName, String imagePath, List<String> notes) {
    final room = getRoomByName(projectId, roomName);
    if (room != null) {
      // Only adds the image if the room exists
      room.images.add(ImageWithNotes(imagePath: imagePath, notes: notes));
      notifyListeners();
    }
  }

  // Method to retrieve a project by its ID
  Project? getProjectById(String projectId) {
    return _projects.firstWhere(
      (proj) => proj.id == projectId,
      orElse: () =>  throw Exception('13'), // Returns null if project is not found
    );
  }

  // Method to retrieve a room by name within a specific project
  Room? getRoomByName(String projectId, String roomName) {
    final project = getProjectById(projectId);
    if (project != null) {
      return project.rooms.firstWhere(
        (rm) => rm.name == roomName,
        orElse: () =>  throw Exception('12'), // Returns null if room is not found
      );
    }
    return null; // Returns null if project is not found
  }

  // Method to update the notes for a specific image in any room of any project
  void updateNotesForImage(String imagePath, List<String> newNotes) {
    for (final project in _projects) {
      for (final room in project.rooms) {
        final image = room.images.firstWhere(
          (img) => img.imagePath == imagePath,
          orElse: () => throw Exception('1'),
        );
        if (image != null) {
          // Updates notes only if image is found
          image.notes = newNotes;
          notifyListeners();
          return; // Exits after updating the first match
        }
      }
    }
  }

  // Method to add an empty image with no notes to a specific room
  void addEmptyImageToRoom(String projectId, String roomName) {
    final room = getRoomByName(projectId, roomName);
    if (room != null) {
      // Only adds the image if the room exists
      room.images.add(ImageWithNotes(imagePath: '', notes: []));
      notifyListeners();
    }
  }
}
