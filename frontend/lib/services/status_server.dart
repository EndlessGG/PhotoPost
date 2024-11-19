import '../services/api_connection.dart';

class StatusServer {
  final ApiConnection apiConnection;

  StatusServer({required this.apiConnection});

  /// Método para obtener el estado del servidor
  Future<Map<String, dynamic>> fetchStatus() async {
    final data = await apiConnection.get('/status');

    if (data['status'] == 'ok') {
      return {
        'message': data['message'],
        'userCount': data['userCount'],
      };
    } else {
      throw Exception('Respuesta no válida: ${data['status']}');
    }
  }
}
