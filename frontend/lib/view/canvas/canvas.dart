import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/project_model.dart'; // Importa el modelo
import 'package:provider/provider.dart';
import '../../controller/project_controller.dart'; // Importa el controlador

class Canvas extends StatefulWidget {
  final ImageWithNotes imageWithNotes;

  const Canvas({super.key, required this.imageWithNotes});

  @override
  _CanvasState createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  bool _isVisible = true;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  double _currentScale = 1.0;
  final double _minScale = 0.5;
  final double _maxScale = 5.0;

  List<Note> notes = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notes = widget.imageWithNotes.notes
        .map((text) => Note(text: text, position: Offset.zero))
        .toList();
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
        notes.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
        notes.clear();
      });
    }
  }

  void _onDoubleTap(TapDownDetails details) {
    setState(() {
      notes.add(
        Note(
          text: '',
          position: details.localPosition,
          isEditing: true,
        ),
      );
    });
  }

  void _zoomin() {
    setState(() {
      if (_currentScale < _maxScale) {
        _currentScale *= 1.2;
        if (_currentScale > _maxScale) {
          _currentScale = _maxScale;
        }
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_currentScale > _minScale) {
        _currentScale /= 1.2;
        if (_currentScale < _minScale) {
          _currentScale = _minScale;
        }
      }
    });
  }

void _saveNotes() {
    final projectController =
        Provider.of<ProjectController>(context, listen: false);
    final updatedNotes = notes.map((note) => note.text).toList();
    projectController.updateNotesForImage(
        widget.imageWithNotes.imagePath, updatedNotes);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveNotes();
            Navigator.pop(context);
          },
        ),
        title: const Text('Título Imagen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: _takePhoto,
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: _zoomin,
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: _zoomOut,
                ),
                IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.brush),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                      _isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: GestureDetector(
                onDoubleTapDown: _onDoubleTap,
                child: Stack(
                  children: [
                    _image == null
                        ? const Center(
                            child: Text(
                              'Toma/Selecciona una Foto',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : InteractiveViewer(
                            boundaryMargin: const EdgeInsets.all(10.0),
                            minScale: _minScale,
                            maxScale: _maxScale,
                            child: Transform.scale(
                              scale: _currentScale,
                              child: Image.file(
                                _image!,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                    for (int i = 0; i < notes.length; i++)
                      Positioned(
                        left: notes[i].position.dx,
                        top: notes[i].position.dy,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              notes[i].position = Offset(
                                notes[i].position.dx + details.delta.dx,
                                notes[i].position.dy + details.delta.dy,
                              );
                            });
                          },
                          child: Container(
                            color: Colors.white.withOpacity(0.8),
                            padding: const EdgeInsets.all(4.0),
                            child: notes[i].isEditing
                                ? SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _textController,
                                      autofocus: true,
                                      onSubmitted: (value) {
                                        setState(() {
                                          notes[i].text = value;
                                          notes[i].isEditing = false;
                                          _textController.clear();
                                        });
                                      },
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        notes[i].isEditing = true;
                                      });
                                    },
                                    child: Text(
                                      notes[i].text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Note {
  String text;
  Offset position;
  bool isEditing;

  Note({
    required this.text,
    required this.position,
    this.isEditing = false,
  });
}
