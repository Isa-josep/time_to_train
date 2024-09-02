import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart'; // Para el calendario
import 'package:time_to_train/features/models/routine_model.dart'; // Modelo de rutina
import 'package:time_to_train/features/presentation/providers.dart';
import 'package:time_to_train/features/presentation/screens/routine_detail_screen.dart'; // Pantalla de detalles de rutina
import 'package:time_to_train/features/presentation/widgets/menu_lat.dart';
import 'package:time_to_train/features/presentation/widgets/routine_modal.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month; // Formato inicial del calendario

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final authState = ref.watch(authProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Time to Train'),
      ),
      body: Column(
        children: [
          // Calendario interactivo
          TableCalendar(
              calendarFormat: _calendarFormat, // Formato de calendario dinámico
              focusedDay: _selectedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                _showRoutinesForSelectedDate(selectedDay);
              },
              formatAnimationCurve: Curves.easeInOut, // Animación de cambio de formato
              formatAnimationDuration: const Duration(milliseconds: 300),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.twoWeeks: '2 Weeks',
                CalendarFormat.week: 'Week',
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              headerVisible: true, 
              availableGestures: AvailableGestures.all, // Gestos disponibles
              // calendarStyle: CalendarStyle(
              //   todayDecoration: BoxDecoration(
              //     color: Colors.blue,
              //     shape: BoxShape.circle,
              //   ),
              //   selectedDecoration: BoxDecoration(
              //     color: Colors.orange,
              //     shape: BoxShape.circle,
              //   ),
              // ),
              ),

          Expanded(
            child: _RoutineList(selectedDay: _selectedDay),
          ),
        ],
      ),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      floatingActionButton: (authState.rol == 'entrenador' || authState.rol == 'admin')
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const RoutineModal(),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showRoutinesForSelectedDate(DateTime date) {
    final routinesAsync = ref.read(routineByDateProvider(date));

    routinesAsync.when(
      data: (routines) {
        if (routines.isNotEmpty) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => _RoutinesModal(routines: routines),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay rutinas para este día.')),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      ),
    );
  }
}

class _RoutineList extends ConsumerWidget {
  final DateTime selectedDay;

  const _RoutineList({required this.selectedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routineByDateProvider(selectedDay));

    return routinesAsync.when(
      data: (routines) {
        if (routines.isEmpty) {
          return const Center(child: Text('No Cuentas Con Una Rutina Asignada'));
        }
        return ListView.builder(
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _RoutinesModal extends StatelessWidget {
  final List<Routine> routines;

  const _RoutinesModal({required this.routines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: routines.map((routine) {
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
        }).toList(),
      ),
    );
  }
}
