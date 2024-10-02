import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/models/routine_model.dart';
import 'package:time_to_train/features/presentation/providers/routine_provider.dart';

final routineByDateProvider = FutureProvider.family<List<Routine>, DateTime>((ref, fecha) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  
  final allRoutines = await routineRepository.fetchRoutinesByDate(fecha);
  print('Todas las rutinas: $allRoutines');
  // Si no hay rutinas, retornamos una lista vacía
  // if (allRoutines.isEmpty) {
  //   print('No hay rutinas para esta fecha');
  //   throw Exception('Sin rutinas para la fecha seleccionada');
  // }
  final filteredRoutines = allRoutines.where((routine) {
  return routine.fechaEjercicio != null &&
         routine.fechaEjercicio!.year == fecha.year &&
         routine.fechaEjercicio!.month == fecha.month &&
         routine.fechaEjercicio!.day == fecha.day;
}).toList();
print('Rutinas filtradas para la fecha $fecha: $filteredRoutines');
return filteredRoutines;
});

//   return allRoutines.where((routine) {
//     return routine.fechaEjercicio != null &&
//            routine.fechaEjercicio!.year == fecha.year &&
//            routine.fechaEjercicio!.month == fecha.month &&
//            routine.fechaEjercicio!.day == fecha.day;
//   }).toList();
// });
