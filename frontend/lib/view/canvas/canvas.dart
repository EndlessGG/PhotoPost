import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Canvas extends StatefulWidget {
  const Canvas({super.key});

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

  List<Note> notes = []; // Lista de notas
  final TextEditingController _textController = TextEditingController();

  // Método para tomar una foto
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
        notes.clear(); // Limpiar notas al cambiar de imagen
      });
    }
  }

  // Método para seleccionar una imagen de la galería
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
        notes.clear(); // Limpiar notas al cambiar de imagen
      });
    }
  }

  // Método para agregar una nota
  void _onDoubleTap(TapDownDetails details) {
    setState(() {
      notes.add(
        Note(
          text: '',
          position: details.localPosition,
          isEditing: true, // Hacer que la nota sea editable inicialmente
        ),
      );
    });
  }

  // Método para aumentar el zoom
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

  // Método para reducir el zoom
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
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
                      _isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
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
                  onDoubleTapDown: _onDoubleTap, // Doble clic para agregar nota
                  child: Stack(
                    children: [
                      _image == null
                          ? const Center(
                              child: Text('Toma/Selecciona una Foto',
                                  style: TextStyle(fontSize: 16)),
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
                      // Mostrar las notas encima de la imagen
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
                                            _textController.clear(); // Limpiar el controlador
                                          });
                                        },
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          notes[i].isEditing = true; // Permitir editar al tocar
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
      ),
    );
  }
}

// Clase para representar cada nota
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

