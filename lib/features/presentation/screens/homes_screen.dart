import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/widgets/horizontal_view_card.dart';
import 'package:time_to_train/features/presentation/widgets/menu_lat.dart';
import 'package:time_to_train/features/presentation/providers/auth_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final authState = ref.watch(authProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Time to Train'),
      ),
      body: _Home(authState.rol),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
    );
  }
}

class _Home extends StatelessWidget {
  final String rol;
  const _Home(this.rol);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              SizedBox(height: 15),
              HorizontalCardView(),
              SizedBox(height: 15),
              HorizontalCardView(),
            ],
          ),
        ),
        if (rol == 'entrenador' || rol == 'admin')
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Acción para agregar rutinas
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}
