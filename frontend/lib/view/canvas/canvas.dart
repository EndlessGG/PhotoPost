import 'package:flutter/material.dart';

class Canvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: Text('Techo'),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: CanvasWithEditableTexts(),
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
