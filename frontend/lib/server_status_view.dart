import 'package:flutter/material.dart';
import './services/status_server.dart'; // Asegúrate de que esta importación sea correcta

class ServerStatusView extends StatefulWidget {
  @override
  _ServerStatusViewState createState() => _ServerStatusViewState();
}

class _ServerStatusViewState extends State<ServerStatusView> {
  late Future<String> _serverStatus;

  @override
  void initState() {
    super.initState();
    _serverStatus = ServerStatus().checkServerStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del Servidor'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _serverStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Estado del servidor: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}
