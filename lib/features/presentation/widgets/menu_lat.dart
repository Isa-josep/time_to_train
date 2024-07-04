import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/config/menu/menu_items.dart';
import 'package:time_to_train/features/presentation/providers/auth_provider.dart';

class SideMenu extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  String getInitials(String name, String apellido) {
    String initials = '';
    if (name.isNotEmpty) {
      initials += name[0]; // Primera letra del primer nombre
    }
    if (apellido.isNotEmpty) {
      initials += apellido[0]; // Primera letra del primer apellido
    }
    return initials.toUpperCase();
  }

  String getShortenedName(String name) {
    if (name.length > 6) {
      return '${name.substring(0, 6)}...';
    }
    return name;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final authState = ref.watch(authProvider);
    final initials = getInitials(authState.nombre, authState.apellido);
    final shortenedName = getShortenedName(authState.nombre);

    return NavigationDrawer(
      selectedIndex: 0,
      onDestinationSelected: (value) {
        final menuItem = appMenuItems[value];
        context.push(menuItem.link);
        scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 0 : 20, 16, 10),
          child: Row(
            children: [
              Text("Hola $shortenedName", style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              CircleAvatar(
                radius: 24, // Ajuste del tamaño del círculo
                backgroundColor: Colors.grey.shade800,
                child: Text(
                  initials,
                  style: const TextStyle(color: Colors.white, fontSize: 18), // Ajuste del tamaño del texto
                ),
              ),
            ],
          ),
        ),
        ...appMenuItems.sublist(0, 3).map(
          (item) => NavigationDrawerDestination(
            icon: Icon(item.icon),
            label: Text(item.title),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text(
            "Más opciones",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...appMenuItems.sublist(3).map(
          (item) => NavigationDrawerDestination(
            icon: Icon(item.icon),
            label: Text(item.title),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Divider(),
        ),
        if (authState.rol == 'admin' || authState.rol == 'entrenador')
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Gestionar Grupos'),
            onTap: () {
              context.push('/manage_groups_screen');
            },
          ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            ref.read(authProvider.notifier).logout();
            context.go('/');
          },
        ),
      ],
    );
  }
}
