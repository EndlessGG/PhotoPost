import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/project_model.dart';

class ProjectController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  ProjectController() {
    _loadProjects();
  }

  // Método para cargar todos los proyectos desde la base de datos al iniciar
  Future<void> _loadProjects() async {
    _projects = await _dbHelper.getProjects();
    print("Proyectos cargados: ${_projects.length}");
    notifyListeners();
  }


  // CRUD para Project

  Future<void> addProject(String name, String? imagePath) async {
    try {
      final project = Project(
        id: DateTime.now().toString(),
        name: name,
        imagePath: imagePath,
        creationDate: DateTime.now(),
        rooms: [],
      );

      await _dbHelper.insertProject(project);
      _projects.add(project);
      notifyListeners();
      print("Proyecto añadido exitosamente");
    } catch (e) {
      print("Error al añadir el proyecto: $e");
    }
  }


  Future<Project?> getProjectById(String projectId) async {
    try {
      return _projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  // CRUD para Room

  Future<void> addRoomToProject(String projectId, String roomName) async {
    final project = await getProjectById(projectId);
    if (project != null) {
      final room = Room(name: roomName, images: []);
      await _dbHelper.insertRoom(projectId, room);
      project.rooms.add(room);
      notifyListeners();
    } else {
      throw Exception("Project not found");
    }
  }

  Future<Room?> getRoomByName(String projectId, String roomName) async {
    final project = await getProjectById(projectId);
    if (project != null) {
      try {
        return project.rooms.firstWhere((room) => room.name == roomName);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Método para eliminar una habitación de un proyecto
  Future<void> deleteRoom(String projectId, String roomName) async {
    final project = await getProjectById(projectId);
    if (project != null) {
      // Elimina la habitación del proyecto en memoria
      project.rooms.removeWhere((room) => room.name == roomName);
      // Elimina la habitación de la base de datos
      await _dbHelper.deleteRoom(projectId, roomName);
      notifyListeners();
    } else {
      throw Exception("Project not found");
    }
  }

  // Método para agregar una imagen vacía a una habitación
  Future<void> addEmptyImageToRoom(String projectId, String roomName) async {
    final room = await getRoomByName(projectId, roomName);
    if (room != null) {
      final image = ImageWithNotes(imagePath: '', notes: []);
      // Agrega la imagen vacía en memoria
      room.images.add(image);
      // Inserta la imagen vacía en la base de datos
      await _dbHelper.insertImage(room.name.hashCode, image);
      notifyListeners();
    } else {
      throw Exception("Room not found");
    }
  }

  // CRUD para ImageWithNotes

  Future<void> addImageToRoom(String projectId, String roomName, String imagePath, List<Note> notes) async {
    final room = await getRoomByName(projectId, roomName);
    if (room != null) {
      final image = ImageWithNotes(imagePath: imagePath, notes: notes);
      await _dbHelper.insertImage(room.name.hashCode, image);
      room.images.add(image);
      notifyListeners();
    } else {
      throw Exception("Room not found");
    }
  }

  // CRUD para Note

  Future<void> addNoteToImage(int imageId, Note note) async {
    await _dbHelper.insertNote(imageId, note);
    notifyListeners();
  }

  // Método para actualizar las notas de una imagen específica
  Future<void> updateNotesForImage(String imagePath, List<Note> newNotes) async {
    for (final project in _projects) {
      for (final room in project.rooms) {
        try {
          final image = room.images.firstWhere((img) => img.imagePath == imagePath);
          image.notes = newNotes;
          for (final note in newNotes) {
            await _dbHelper.insertNote(imagePath.hashCode, note);
          }
          notifyListeners();
          return;
        } catch (e) {
          // Continuar al siguiente room si no se encuentra la imagen
        }
      }
    }
    throw Exception("Image not found");
  }

  // Método para actualizar la ruta de la imagen en una ImageWithNotes
  Future<void> updateImagePath(ImageWithNotes imageWithNotes, String imagePath) async {
    imageWithNotes.imagePath = imagePath;
    await _dbHelper.insertImage(imageWithNotes.hashCode, imageWithNotes);
    notifyListeners();
  }

  // Método para borrar todos los datos (para pruebas)
  Future<void> clearAllData() async {
    await _dbHelper.clearDatabase();
    _projects.clear();
    notifyListeners();
  }
}
