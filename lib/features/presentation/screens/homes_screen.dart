import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/models/routine_model.dart';
import 'package:time_to_train/features/presentation/providers/auth_provider.dart';
import 'package:time_to_train/features/presentation/providers/routine_provider.dart';
import 'package:time_to_train/features/presentation/screens/routine_detail_screen.dart';
import 'package:time_to_train/features/presentation/widgets/menu_lat.dart';
import 'package:time_to_train/features/presentation/widgets/routine_modal.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final authState = ref.watch(authProvider);
    final routinesAsync = ref.watch(routineProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Time to Train'),
      ),
      body: routinesAsync.when(
        data: (routines) => _Home(authState.rol, routines),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
    );
  }
}

class _Home extends StatelessWidget {
  final String rol;
  final List<Routine> routines;
  const _Home(this.rol, this.routines);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView.builder(
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Card(
                child: ListTile(
                  title: Text(routine.nombre),
                  subtitle: Text(routine.descripcion),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoutineDetailScreen(routine: routine),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (rol == 'entrenador' || rol == 'admin')
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const RoutineModal(),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}
