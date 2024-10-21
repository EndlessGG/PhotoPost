import 'package:flutter/material.dart';
import './view/home/home.dart'; // Asegúrate de importar correctamente HomeView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(), // Establece HomeView como la vista inicial
    );
  }
}
