class Project {
  final String id;
  final String name;
  final String? imagePath;
  List<String> rooms; // Make this a regular, modifiable list

  // Modify the constructor to initialize 'rooms' as a regular list, not a constant
  Project(
      {required this.id,
      required this.name,
      this.imagePath,
      List<String>? rooms})
      : rooms =
            rooms ?? []; // Default to an empty list if 'rooms' is not provided
}
