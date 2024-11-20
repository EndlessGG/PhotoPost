import 'package:flutter/material.dart';

class Project {
  final String id;
  final String name;
  final String? imagePath;
  final DateTime creationDate; 
  List<Room> rooms;

  Project({
    required this.id,
    required this.name,
    this.imagePath,
    required this.creationDate,
    List<Room>? rooms,
  }) : rooms = rooms ?? [];
}

class Room {
  final String name;
  List<ImageWithNotes> images;

  Room({
    required this.name,
    List<ImageWithNotes>? images,
  }) : images = images ?? [];
}

class ImageWithNotes {
  String imagePath;
  List<Note> notes; // Use List<Note> instead of List<String>
  List<List<Offset>> trazos; // Agregar trazos para almacenar cada trazo como lista de puntos

  ImageWithNotes({
    required this.imagePath,
    List<Note>? notes,
    List<List<Offset>>? trazos,
  }) : notes = notes ?? [],
      trazos = trazos ?? []; // Inicializar como lista vacía

  // Optional: JSON serialization to save/load the data
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'notes': notes.map((note) => note.toJson()).toList(),
      };

  factory ImageWithNotes.fromJson(Map<String, dynamic> json) => ImageWithNotes(
        imagePath: json['imagePath'],
        notes: (json['notes'] as List)
            .map((noteJson) => Note.fromJson(noteJson))
            .toList(),
      );
}

// Define Note as part of the model to store text and position
class Note {
  String text;
  Offset position;
  bool isEditing;

  Note({
    required this.text,
    required this.position,
    this.isEditing = false,
  });

  // Serialization to save/load the data
  Map<String, dynamic> toJson() => {
        'text': text,
        'positionX': position.dx,
        'positionY': position.dy,
        'isEditing': isEditing,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        text: json['text'],
        position: Offset(json['positionX'], json['positionY']),
        isEditing: json['isEditing'] ?? false,
      );
}
