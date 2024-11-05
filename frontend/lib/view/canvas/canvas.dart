import 'dart:io';
import 'dart:ui' as ui; // Necesario para crear una imagen con trazos
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
  bool _isDrawing = false; // Para activar/desactivar el modo de dibujo
  File? _image;
  final ImagePicker _picker = ImagePicker();
  double _currentScale = 1.0;
  final double _minScale = 0.5;
  final double _maxScale = 5.0;
  final TextEditingController _textController = TextEditingController();
  
  List<Offset> _points = []; // Almacena los puntos del trazo

  @override
  void initState() {
    super.initState();
    // Cargar imagen existente si imagePath está configurado
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

  // Función para guardar la imagen con los trazos en almacenamiento interno
  Future<void> _saveImageWithDrawings() async {
    if (_image == null) return;

    // Crear un lienzo con las dimensiones de la imagen original
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final image = await _image!.readAsBytes();
    final ui.Image uiImage = await decodeImageFromList(image);

    // Dibujar la imagen original en el lienzo
    canvas.drawImage(uiImage, Offset.zero, Paint());

    // Dibujar los trazos almacenados sobre el lienzo
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i], _points[i + 1], paint);
      }
    }

    // Convertir el lienzo en una imagen
    final ui.Image finalImage = await recorder.endRecording().toImage(
      uiImage.width,
      uiImage.height,
    );

    // Convertir la imagen a bytes PNG
    final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Guardar la imagen modificada en almacenamiento interno
    final String path = widget.imageWithNotes.imagePath;
    final File newImageFile = await File(path).writeAsBytes(pngBytes);

    // Actualizar la imagen en la interfaz
    setState(() {
      _image = newImageFile;
    });
  }

  // Método que activa/desactiva el modo de dibujo
  void _toggleDrawingMode() {
    setState(() {
      _isDrawing = !_isDrawing;
      if (!_isDrawing) {
        _points.clear(); // Limpia los puntos cuando se desactiva el modo de dibujo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveImageWithDrawings(); // Guarda la imagen con los trazos al volver atrás
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.brush),
                  onPressed: _toggleDrawingMode, // Activa/desactiva el modo de dibujo
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
            child: GestureDetector(
              onPanUpdate: (details) {
                // Agregar puntos a la lista mientras se dibuja
                if (_isDrawing) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                }
              },
              onPanEnd: (details) {
                // Agregar un marcador null para indicar un nuevo trazo
                _points.add(Offset.infinite);
              },
              child: Stack(
                children: [
                  _image == null
                      ? const Center(child: Text('Toma/Selecciona una Foto'))
                      : InteractiveViewer(
                          minScale: _minScale,
                          maxScale: _maxScale,
                          child: Image.file(
                            _image!,
                            fit: BoxFit.contain,
                          ),
                        ),
                  // Dibuja los trazos sobre la imagen
                  CustomPaint(
                    size: Size.infinite,
                    painter: _DrawingPainter(_points),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase CustomPainter para dibujar los trazos en la pantalla
class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  
  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => oldDelegate.points != points;
}
