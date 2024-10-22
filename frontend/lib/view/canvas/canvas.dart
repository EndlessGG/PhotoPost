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

  double _currentScale = 1.0; // para el nivel del zoom inicial
  final double _minScale = 0.5; // minimo de zom
  final double _maxSacale = 5.0; // maximo de zoom

  // Metodo para tomar una foto con la camara (En caso de que la foto no salga de manera correcta)
  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Se almacena la imagen seleccionada
        _currentScale = 1.0; // Reiniciar el zoom al seleccionar nueva imagen
      });
    }
  }

  // Metodod para selccionar una imagen de la galeria del movil
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _currentScale = 1.0;
      });
    }
  }

  // Metodo para aumenar el zoom en img
  void _zoomin() {
    setState(() {
      if (_currentScale < _maxSacale) {
        _currentScale *= 1.2; // aumenta el zoom en un 20%

        if (_currentScale > _maxSacale) {
          _currentScale = _maxSacale; // limitamos la sacala maxima de zoom
        }
      }
    });
  }

  // Metodo para reducir el zoom en img
  void _zoomOut() {
    setState(() {
      if (_currentScale > _minScale) {
        _currentScale /= 1.2; // Disminye la escala en un 20%
        if (_currentScale < _minScale) {
          _currentScale = _minScale; // Limita la escala al mnimo
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
          title: const Text('Titulo Imagen'),
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
                    onPressed: () {
                      _pickImage(); // se invoica al metodo para seleccionar una foto
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera),
                    onPressed: () {
                      _takePhoto(); // Se invoca el metodo para volver a tomar la foto
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: () {
                      _zoomin();
                    },
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.zoom_out),
                  //   onPressed: () {},
                  // ),
                  IconButton(
                    icon: const Icon(Icons.text_fields),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.brush),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.note),
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
                child: Center(
                  child: _image == null
                      ? const Text('Toma/Selecciona una Foto',
                          style: TextStyle(fontSize: 16))
                      : InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(10.0),
                          minScale: _minScale,
                          maxScale: _maxSacale,
                          child: Transform.scale(
                            scale: _currentScale, // Aplica el nivel de zoom
                            child: Image.file(
                              _image!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
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

class CanvasWithEditableTexts extends StatefulWidget {
  @override
  _CanvasWithEditableTextsState createState() => _CanvasWithEditableTextsState();
}

class _CanvasWithEditableTextsState extends State<CanvasWithEditableTexts> {
  List<Note> notes = [];
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.bookmark),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.grid_view),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.text_fields),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
              Switch(
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onDoubleTapDown: (details) {
              setState(() {
                notes.add(Note(
                  text: '',
                  position: details.localPosition,
                  isEditing: true,
                ));
              });
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text('imagen tomada', style: TextStyle(fontSize: 16)),
                  ),
                  // Renderiza todas las notas
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
                                        _textController.clear(); // Limpia el controlador
                                      });
                                    },
                                  ),
                                )
                              : Text(
                                  notes[i].text,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
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
    );
  }
}

// Clase que representa cada nota con su texto y posición
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
