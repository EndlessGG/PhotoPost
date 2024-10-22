import 'dart:convert';
import 'api_connection.dart'; // importacion de Conexion de la API

class ServerStatus {
  final ApiConnection _apiConnection = ApiConnection(); // Instancia de ApiConnection

  // Metodo para verificar el estado del servidor con uso del metodo get de api_connection.dart en lane 10
  Future<String> checkServerStatus() async {
    final response = await _apiConnection.get('/status-server'); // Se llama al metodo GET con la ruta '/status-server' que esta en la ruta del BackEnd

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      throw Exception('Error al obtener el estado del servidor');
    }
  }

  // Mas metodos relacionados con el estado del servidor...
}