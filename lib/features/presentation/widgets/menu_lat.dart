import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/config/menu/menu_items.dart';
import 'package:time_to_train/features/presentation/providers/user_provider.dart';

final clearTextFieldsProvider = Provider<VoidCallback>((ref) => () {});

class SideMenu extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final user = ref.watch(userProvider);
    final clearTextFields = ref.watch(clearTextFieldsProvider);

    return NavigationDrawer(
      selectedIndex: 0,
      onDestinationSelected: (value) {
        if (value == appMenuItems.length) {
          // Logout selected
          ref.read(userProvider.notifier).state = null; // Limpia el estado del usuario
          clearTextFields(); // Limpia los campos de texto
          context.go('/'); // Redirige a la pantalla de login
        } else {
          final menuItem = appMenuItems[value];
          context.push(menuItem.link);
        }
        scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 0 : 20, 16, 10),
          child: Row(
            children: [
              Text(
                "Hola ${user?.username ?? 'Usuario'}", // Muestra el username del usuario si está disponible
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Padding(padding: EdgeInsets.only(left: 30)),
              const Icon(
                Icons.account_circle,
                size: 40,
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
          child: Divider(), // ** crea una línea divisora
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
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Divider(), // ** crea una línea divisora
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.logout),
          label: Text('Logout'),
        ),
      ],
    );
  }
}
