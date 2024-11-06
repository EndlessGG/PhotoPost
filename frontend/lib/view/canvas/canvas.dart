import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/project_model.dart';
import 'package:provider/provider.dart';
import '../../controller/project_controller.dart';

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
  final TextEditingController _textController = TextEditingController();

  // Variables para el ícono temporal
  Offset? _tempIconPosition;
  bool _showTempIcon = false;

  @override
  void initState() {
    super.initState();
    widget.imageWithNotes.notes = widget.imageWithNotes.notes;

    if (widget.imageWithNotes.imagePath.isNotEmpty) {
      _image = File(widget.imageWithNotes.imagePath);
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
        widget.imageWithNotes.notes.clear();
        widget.imageWithNotes.imagePath = pickedFile.path;
      });
      Provider.of<ProjectController>(context, listen: false).updateImagePath(
        widget.imageWithNotes,
        pickedFile.path,
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
        widget.imageWithNotes.notes.clear();
        widget.imageWithNotes.imagePath = pickedFile.path;
      });
      Provider.of<ProjectController>(context, listen: false).updateImagePath(
        widget.imageWithNotes,
        pickedFile.path,
      );
    }
  }

  void _onDoubleTap(TapDownDetails details) {
    setState(() {
      widget.imageWithNotes.notes.add(
        Note(
          text: '',
          position: details.localPosition,
          isEditing: true,
        ),
      );
    });
  }

  void _saveNotes() {
    final projectController = Provider.of<ProjectController>(context, listen: false);
    projectController.updateNotesForImage(
      widget.imageWithNotes.imagePath,
      widget.imageWithNotes.notes,
    );
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

  void _showConfirmationIcon(Offset position) {
    setState(() {
      _tempIconPosition = position;
      _showTempIcon = true;
    });

    // Oculta el ícono después de 1 segundo
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showTempIcon = false;
      });
    });
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
                  icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
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
                    if (_showTempIcon && _tempIconPosition != null)
                      Positioned(
                        left: _tempIconPosition!.dx,
                        top: _tempIconPosition!.dy,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.blue, //color azul el icono*
                          size: 30,
                        ),
                      ),
                    if (_isVisible)
                      for (int i = 0; i < widget.imageWithNotes.notes.length; i++)
                        Positioned(
                          left: widget.imageWithNotes.notes[i].position.dx,
                          top: widget.imageWithNotes.notes[i].position.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                widget.imageWithNotes.notes[i].position = Offset(
                                  widget.imageWithNotes.notes[i].position.dx + details.delta.dx,
                                  widget.imageWithNotes.notes[i].position.dy + details.delta.dy,
                                );
                              });
                            },
                            child: widget.imageWithNotes.notes[i].isEditing
                                ? SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _textController,
                                      autofocus: true,
                                      onSubmitted: (value) {
                                        setState(() {
                                          widget.imageWithNotes.notes[i].text = value;
                                          widget.imageWithNotes.notes[i].isEditing = false;
                                          _textController.clear();
                                          // Muestra el ícono de confirmación después de guardar la nota
                                          _showConfirmationIcon(widget.imageWithNotes.notes[i].position);
                                        });
                                      },
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.imageWithNotes.notes[i].isEditing = true;
                                      });
                                    },
                                    child: Text(
                                      widget.imageWithNotes.notes[i].text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
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
