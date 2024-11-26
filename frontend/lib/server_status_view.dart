import 'package:flutter/material.dart';
import './services/status_server.dart';
import './services/api_connection.dart';

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final StatusServer statusRepository = 
      StatusServer(apiConnection: ApiConnection());

  late Future<Map<String, dynamic>> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = statusRepository.fetchStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado del Servidor'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _statusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Mensaje: ${data['message']}'),
                  Text('Cantidad de usuarios: ${data['userCount']}'),
                ],
              );
            } else {
              return Text('No se encontraron datos.');
            }
          },
        ),
      ),
    );
  }
}
