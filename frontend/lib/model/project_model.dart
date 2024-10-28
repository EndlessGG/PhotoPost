class Project {
  final String id;
  final String name;
  final String? imagePath;
  List<Room> rooms;

  Project({
    required this.id,
    required this.name,
    this.imagePath,
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
  List<String> notes;

  ImageWithNotes({
    required this.imagePath,
    List<String>? notes,
  }) : notes = notes ?? [];
}
