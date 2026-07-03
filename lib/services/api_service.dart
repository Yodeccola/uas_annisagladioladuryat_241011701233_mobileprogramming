import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/buku';

  static Future<List<dynamic>> getBuku() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) return json.decode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addBuku(String judul, String penulis, String genre, String sinopsis, String coverUrl) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul': judul,
          'penulis': penulis,
          'genre': genre,
          'sinopsis': sinopsis,
          'coverUrl': coverUrl
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateBuku(int id, String judul, String penulis, String genre, String sinopsis, String coverUrl) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul': judul,
          'penulis': penulis,
          'genre': genre,
          'sinopsis': sinopsis,
          'coverUrl': coverUrl
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteBuku(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}