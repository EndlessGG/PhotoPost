import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/project_model.dart';
import 'package:provider/provider.dart';
import '../../controller/project_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Canvas extends StatefulWidget {
  final ImageWithNotes imageWithNotes;

  const Canvas({super.key, required this.imageWithNotes});

  @override
  _CanvasState createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  bool _isVisible = true;
  bool _isDrawing = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  double _currentScale = 1.0;
  final double _minScale = 0.5;
  final double _maxScale = 5.0;
  final TextEditingController _textController = TextEditingController();
  List<Offset> _points = [];

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

  void _toggleDrawingMode() {
    setState(() {
      _isDrawing = !_isDrawing;
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

    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showTempIcon = false;
      });
    });
  }

  Future<void> _saveCanvasAsPdf() async {
    if (await Permission.storage.request().isGranted) {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  if (_image != null)
                    pw.Image(pw.MemoryImage(_image!.readAsBytesSync())),
                  pw.SizedBox(height: 20),
                  pw.Text("Notas:"),
                  pw.Column(
                    children: widget.imageWithNotes.notes.map((note) {
                      return pw.Text("• ${note.text}");
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final directory = Directory('/storage/emulated/0/Download');
      final file = File("${directory.path}/canvas_output.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF guardado en: ${file.path}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permiso de almacenamiento denegado")),
      );
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDrawing) {
      setState(() {
        _points.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDrawing) {
      setState(() {
        _points.add(Offset.infinite); // Marca el fin del trazo
        widget.imageWithNotes.trazos.add(List.from(_points)); // Guarda el trazo completo
        _points.clear(); // Limpia los puntos temporales
      });
    }
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
            icon: const Icon(Icons.save_alt),
            onPressed: _saveCanvasAsPdf,
          ),
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
                IconButton(icon: const Icon(Icons.bookmark), onPressed: () {}),
                IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
                IconButton(icon: const Icon(Icons.camera), onPressed: _takePhoto),
                IconButton(icon: const Icon(Icons.zoom_in), onPressed: _zoomin),
                IconButton(icon: const Icon(Icons.zoom_out), onPressed: _zoomOut),
                IconButton(icon: const Icon(Icons.text_fields), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.brush),
                  onPressed: _toggleDrawingMode,
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
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
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
                          color: Colors.blue,
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
                    CustomPaint(
                      size: Size.infinite,
                      painter: _DrawingPainter(widget.imageWithNotes.trazos, _points),
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

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> trazos;
  final List<Offset> currentPoints;

  _DrawingPainter(this.trazos, this.currentPoints);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (var trazo in trazos) {
      for (int i = 0; i < trazo.length - 1; i++) {
        if (trazo[i] != Offset.infinite && trazo[i + 1] != Offset.infinite) {
          canvas.drawLine(trazo[i], trazo[i + 1], paint);
        }
      }
    }

    for (int i = 0; i < currentPoints.length - 1; i++) {
      if (currentPoints[i] != Offset.infinite && currentPoints[i + 1] != Offset.infinite) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) =>
      oldDelegate.currentPoints != currentPoints || oldDelegate.trazos != trazos;
}
