import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Clase que manejará la lógica de los videos
class VideosNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  VideosNotifier() : super([]) {
    fetchVideos(); // Cargar videos al iniciar
  }

  // URL base de tu API
  final String _baseUrl = '${dotenv.env['API_URL']}api/routines';

  // Método para obtener los videos desde la API
  Future<void> fetchVideos() async {
    final url = Uri.parse('$_baseUrl/videos');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        state = List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al obtener videos');
      }
    } catch (error) {
      throw error;
    }
  }

  // Método para agregar un video
  Future<void> addVideo(String titulo, String url) async {
    final videoData = {
      'titulo': titulo,
      'url': url,
    };

  // Método para actualizar un video
Future<void> updateVideo(int id, String titulo, String url) async {
  final videoData = {
    'titulo': titulo,
    'url': url,
  };

  final response = await http.put(
    Uri.parse('$_baseUrl/videos/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(videoData),
  );

  if (response.statusCode == 200) {
    fetchVideos(); // Actualiza la lista de videos
  } else {
    throw Exception('Error al actualizar video');
  }
}


    final response = await http.post(
      Uri.parse('$_baseUrl/videos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(videoData),
    );

    if (response.statusCode == 201) {
      fetchVideos(); // Actualiza la lista de videos
    } else {
      throw Exception('Error al agregar video');
    }
  }

  // Método para eliminar un video
  Future<void> deleteVideo(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/videos/$id'));

    if (response.statusCode == 200) {
      fetchVideos(); // Actualiza la lista de videos
    } else {
      throw Exception('Error al eliminar video');
    }
  }

  // Método para actualizar un video (opcional si necesitas actualizar videos)
  Future<void> updateVideo(int id, String titulo, String url) async {
    final videoData = {
      'titulo': titulo,
      'url': url,
    };

    final response = await http.put(
      Uri.parse('$_baseUrl/videos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(videoData),
    );

    if (response.statusCode == 200) {
      fetchVideos(); // Actualiza la lista de videos
    } else {
      throw Exception('Error al actualizar video');
    }
  }
}

// Define el provider de Riverpod
final videosProvider = StateNotifierProvider<VideosNotifier, List<Map<String, dynamic>>>((ref) {
  return VideosNotifier();
});
