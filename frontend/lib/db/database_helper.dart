import 'dart:async';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/project_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'projects.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Método para eliminar una habitación por nombre y projectId
  Future<void> deleteRoom(String projectId, String roomName) async {
    final db = await database;
    await db.delete(
      'rooms',
      where: 'projectId = ? AND name = ?',
      whereArgs: [projectId, roomName],
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects (
        id TEXT PRIMARY KEY,
        name TEXT,
        imagePath TEXT,
        creationDate TEXT 
      )
    ''');

    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId TEXT,
        name TEXT,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        roomId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (roomId) REFERENCES rooms (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageId INTEGER,
        text TEXT,
        positionX REAL,
        positionY REAL,
        FOREIGN KEY (imageId) REFERENCES images (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE trazos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageId INTEGER,
        positionX REAL,
        positionY REAL,
        FOREIGN KEY (imageId) REFERENCES images (id) ON DELETE CASCADE
      )
    ''');

  }

  // CRUD Operations for Project

  Future<void> insertProject(Project project) async {
    final db = await database;
    print("Insertando proyecto con ID: ${project.id}, Nombre: ${project.name}, Fecha de creación: ${project.creationDate}");
    
    await db.insert(
      'projects',
      {
        'id': project.id,
        'name': project.name,
        'imagePath': project.imagePath,
        'creationDate': project.creationDate.toIso8601String(), // Asegúrate de guardar la fecha en ISO8601
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Proyecto insertado en la base de datos");
  }


  Future<List<Project>> getProjects() async {
    final db = await database;
    final maps = await db.query('projects');
    List<Project> projects = [];
    for (var map in maps) {
      final rooms = await getRooms(map['id'] as String);
      projects.add(Project(
        id: map['id'] as String,
        name: map['name'] as String,
        creationDate: DateTime.parse(map['creationDate'] as String),
        imagePath: map['imagePath'] as String?,
        rooms: rooms,
      ));
    }
    return projects;
  }

  // CRUD Operations for Room

  Future<void> insertRoom(String projectId, Room room) async {
    final db = await database;
    await db.insert(
      'rooms',
      {
        'projectId': projectId,
        'name': room.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Room>> getRooms(String projectId) async {
    final db = await database;
    final maps = await db.query(
      'rooms',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );

    List<Room> rooms = [];
    for (var map in maps) {
      final images = await getImages(map['id'] as int);
      rooms.add(Room(
        name: map['name'] as String,
        images: images,
      ));
    }
    return rooms;
  }

  // CRUD Operations for ImageWithNotes

  Future<void> insertImage(int roomId, ImageWithNotes image) async {
    final db = await database;
    await db.insert(
      'images',
      {
        'roomId': roomId,
        'imagePath': image.imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ImageWithNotes>> getImages(int roomId) async {
    final db = await database;
    final maps = await db.query(
      'images',
      where: 'roomId = ?',
      whereArgs: [roomId],
    );

    List<ImageWithNotes> images = [];
    for (var map in maps) {
      final notes = await getNotes(map['id'] as int);
      final trazos = await getTrazos(map['id'] as int); // Obtiene los trazos
      images.add(ImageWithNotes(
        imagePath: map['imagePath'] as String,
        notes: notes,
        trazos: trazos,
      ));
    }
    return images;
  }


  // CRUD Operations for Note

  Future<void> insertNote(int imageId, Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      {
        'imageId': imageId,
        'text': note.text,
        'positionX': note.position.dx,
        'positionY': note.position.dy,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes(int imageId) async {
    final db = await database;
    final maps = await db.query(
      'notes',
      where: 'imageId = ?',
      whereArgs: [imageId],
    );

    return List.generate(maps.length, (i) {
      return Note(
        text: maps[i]['text'] as String,
        position: Offset(maps[i]['positionX'] as double, maps[i]['positionY'] as double),
        isEditing: false,
      );
    });
  }

  Future<void> insertTrazo(int imageId, Offset punto) async {
    final db = await database;
    await db.insert(
      'trazos',
      {
        'imageId': imageId,
        'positionX': punto.dx,
        'positionY': punto.dy,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<List<Offset>>> getTrazos(int imageId) async {
    final db = await database;
    final maps = await db.query(
      'trazos',
      where: 'imageId = ?',
      whereArgs: [imageId],
    );

    List<List<Offset>> trazos = [];
    List<Offset> trazoActual = [];
    for (var map in maps) {
      Offset punto = Offset(map['positionX'] as double, map['positionY'] as double);
      if (punto == Offset.infinite) {
        trazos.add(List.from(trazoActual)); // Guarda el trazo actual y reinicia
        trazoActual = [];
      } else {
        trazoActual.add(punto); // Añadir puntos a trazo actual
      }
    }
    if (trazoActual.isNotEmpty) trazos.add(trazoActual); // Añadir el último trazo
    return trazos;
  }



  // Delete all entries (useful for resetting database during testing)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('projects');
    await db.delete('rooms');
    await db.delete('images');
    await db.delete('notes');
  }
//ejemplo
  
}
