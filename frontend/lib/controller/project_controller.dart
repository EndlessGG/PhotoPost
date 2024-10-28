import 'package:flutter/material.dart';
import '../model/project_model.dart';

class ProjectController extends ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  void addProject(String name, String? imagePath) {
    final newProject = Project(
      id: DateTime.now().toString(),
      name: name,
      imagePath: imagePath,
      rooms: [],
    );
    _projects.add(newProject);
    notifyListeners();
  }

  void addRoomToProject(String projectId, String roomName) {
    final project = getProjectById(projectId);
    if (project != null) {
      project.rooms.add(Room(name: roomName, images: []));
      notifyListeners();
    }
  }

  void addImageToRoom(
      String projectId, String roomName, String imagePath, List<String> notes) {
    final room = getRoomByName(projectId, roomName);
    if (room != null) {
      room.images.add(ImageWithNotes(imagePath: imagePath, notes: notes));
      notifyListeners();
    }
  }

Project? getProjectById(String projectId) {
    print("Searching for project with ID: $projectId");

    // Print all available project IDs for reference
    print("Available projects:");
    for (var project in _projects) {
      print("Project ID: ${project.id}, Project Name: ${project.name}");
    }

    // Attempt to find the project by ID
    try {
      final project = _projects.firstWhere(
        (proj) => proj.id == projectId,
        orElse: () {
          print("Project with ID $projectId not found in the list.");
          return throw Exception('13'); // Return null instead of throwing an exception
        },
      );

      // Print the result if a project is found
      if (project != null) {
        print("Found project: ${project.name} with ID: ${project.id}");
      }

      return project;
    } catch (e) {
      // Catch any unexpected errors
      print("An error occurred while searching for the project: $e");
      return null; // Return null to handle gracefully
    }
  }

  Room? getRoomByName(String projectId, String roomName) {
    print(projectId + "aqui2");
    final project = getProjectById(projectId);
    if (project != null) {
      return project.rooms.firstWhere((rm) => rm.name == roomName,
          orElse: () => throw Exception('12'));
    }
    return null;
  }

  void updateNotesForImage(String imagePath, List<String> newNotes) {
    for (final project in _projects) {
      for (final room in project.rooms) {
        final image = room.images.firstWhere(
            (img) => img.imagePath == imagePath,
            orElse: () => throw Exception('1'));
        if (image != null) {
          image.notes = newNotes;
          notifyListeners();
          return;
        }
      }
    }
  }

// Method to add an empty image with notes to a specific room
  void addEmptyImageToRoom(String projectId, String roomName) {
    print(
        "Attempting to add an empty image to room '$roomName' in project '$projectId'.");

    // Print out the list of projects to verify if the project exists
    print("Current projects:");
    for (var project in _projects) {
      print("Project ID: ${project.id}, Project Name: ${project.name}");
    }

    final room = getRoomByName(projectId, roomName);

    // Check if the room was found
    if (room != null) {
      print("Room '$roomName' found. Adding an empty image.");
      room.images.add(ImageWithNotes(imagePath: '', notes: []));
      notifyListeners(); // Notify listeners after adding the image
    } else {
      print("Room '$roomName' not found in project '$projectId'.");
    }
  }

void updateImagePath(ImageWithNotes imageWithNotes, String imagePath) {
    imageWithNotes.imagePath = imagePath;
    notifyListeners(); // Notify listeners to update UI
  }

}
