import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConnection {
  final String baseUrl;

  ApiConnection({this.baseUrl = "https://photopost.up.railway.app"});

  /// Metodo GET
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión GET: $e');
    }
  }

  /// Metodo POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión POST: $e');
    }
  }

  /// Metodo PUT
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error PUT: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión PUT: $e');
    }
  }

  /// Metodo DELETE
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } else {
        throw Exception('Error DELETE: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión DELETE: $e');
    }
  }
}
