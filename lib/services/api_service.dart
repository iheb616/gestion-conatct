import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class ApiService {
  // Configure this to match your backend URL
  // For Android emulator: use http://10.0.2.2:8000
  // For physical device: use your computer's local IP (e.g., http://192.168.1.x:8000)
  // For web: use http://localhost:8000
  static const String baseUrl = 'http://localhost:8000';
  static const Duration _timeout = Duration(seconds: 10);

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<T> _handleRequest<T>(
    Future<http.Response> Function() request,
    T Function(dynamic) parser,
  ) async {
    try {
      final response = await request().timeout(_timeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return parser(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Request failed');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Authentication methods
  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      ),
      (data) => data as Map<String, dynamic>,
    );
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      ),
      (data) => data as Map<String, dynamic>,
    );
  }

  // Contact methods
  static Future<List<Person>> getPersons() async {
    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl/personnes'),
        headers: _headers,
      ),
      (data) => (data as List).map((json) => Person.fromJson(json)).toList(),
    );
  }

  static Future<String> addPerson(Person person) async {
    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl/personnes'),
        headers: _headers,
        body: json.encode(person.toJson()),
      ),
      (_) => 'Contact added successfully',
    );
  }

  static Future<String> deletePerson(int id) async {
    return _handleRequest(
      () => http.delete(
        Uri.parse('$baseUrl/personnes/$id'),
        headers: _headers,
      ),
      (_) => 'Contact deleted successfully',
    );
  }
}
