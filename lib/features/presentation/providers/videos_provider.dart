import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class VideosNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  VideosNotifier() : super([]) {
    fetchVideos();
  }

  final String _baseUrl = '${dotenv.env['API_URL']}graphql';

  Future<void> fetchVideos() async {
    const query = '''
    query {
      obtenerVideos {
        id
        titulo
        url
      }
    }
    ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      state = List<Map<String, dynamic>>.from(json.decode(response.body)['data']['obtenerVideos']);
    } else {
      throw Exception('Error al obtener videos');
    }
  }

  Future<void> addVideo(String titulo, String url) async {
    const mutation = '''
    mutation AgregarVideo(\$titulo: String!, \$url: String!) {
      addVideo(titulo: \$titulo, url: \$url) {
        id
        titulo
        url
      }
    }
    ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': mutation,
        'variables': {
          'titulo': titulo,
          'url': url,
        },
      }),
    );

    if (response.statusCode == 201) {
      fetchVideos();
    } else {
      throw Exception('Error al agregar video');
    }
  }

  Future<void> updateVideo(int id, String titulo, String url) async {
    const mutation = '''
    mutation ActualizarVideo(\$id: Int!, \$titulo: String!, \$url: String!) {
      updateVideo(id: \$id, titulo: \$titulo, url: \$url) {
        id
        titulo
        url
      }
    }
    ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': mutation,
        'variables': {
          'id': id,
          'titulo': titulo,
          'url': url,
        },
      }),
    );

    if (response.statusCode == 200) {
      fetchVideos();
    } else {
      throw Exception('Error al actualizar video');
    }
  }

  Future<void> deleteVideo(int id) async {
    const mutation = '''
    mutation EliminarVideo(\$id: Int!) {
      deleteVideo(id: \$id) {
        success
      }
    }
    ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': mutation,
        'variables': {'id': id},
      }),
    );

    if (response.statusCode == 200) {
      fetchVideos();
    } else {
      throw Exception('Error al eliminar video');
    }
  }
}

final videosProvider = StateNotifierProvider<VideosNotifier, List<Map<String, dynamic>>>((ref) {
  return VideosNotifier();
});
