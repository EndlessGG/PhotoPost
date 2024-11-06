//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiConnection {
  final String baseUrl;

  ApiConnection() : baseUrl = 'http://192.168.100.6:3000/api';

  // Metodo para realizar solicitudes GET
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url);
  }

  // Mwtodo para realizar solicitudes POST
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // Metodo para realizar solicitudes PUT
  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // Metodo para realizar solicitudes DELETE
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(url);
  }

  // Este archivo es solo la conexion, puedes hacer uso de esta conexion como en el ejemplo de status_server segun el metodo que requieras
}
