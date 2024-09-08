import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/providers.dart';

class ManagerVideos extends ConsumerWidget {
  const ManagerVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accede al provider para obtener los videos
    final videos = ref.watch(videosProvider);
    final videosNotifier = ref.read(videosProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Videos'),
      ),
      body: videos.isEmpty
          ? const Center(
              child: Text('No tienes videos agregados'),
            )
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (ctx, index) {
                final video = videos[index];
                return ListTile(
                  title: Text(video['titulo']),
                  subtitle: Text(video['url']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditVideoDialog(context, videosNotifier, video['id'], video['titulo'], video['url']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await videosNotifier.deleteVideo(video['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVideoDialog(context, videosNotifier);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialogo para agregar nuevo video
  void _showAddVideoDialog(BuildContext context, VideosNotifier videosNotifier) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Agregar Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL del video'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final titulo = titleController.text;
                final url = urlController.text;

                if (titulo.isNotEmpty && url.isNotEmpty) {
                  await videosNotifier.addVideo(titulo, url);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Dialogo para editar un video
  void _showEditVideoDialog(BuildContext context, VideosNotifier videosNotifier, int id, String currentTitle, String currentUrl) {
    final titleController = TextEditingController(text: currentTitle);
    final urlController = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Editar Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL del video'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final nuevoTitulo = titleController.text;
                final nuevaUrl = urlController.text;

                if (nuevoTitulo.isNotEmpty && nuevaUrl.isNotEmpty) {
                  await videosNotifier.updateVideo(id, nuevoTitulo, nuevaUrl);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
