class Routine {
  final int id;
  final String nombre;
  final String descripcion;
  final int usuarioId;
  final int grupoId;
  final String? videoUrl;
  final DateTime fechaEjercicio;

  Routine({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.usuarioId,
    required this.grupoId,
    this.videoUrl,
    required this.fechaEjercicio,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      usuarioId: json['usuario_id'],
      grupoId: json['grupo_id'],
      videoUrl: json['video_url'],
      fechaEjercicio: DateTime.parse(json['fecha_ejercicio']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'usuario_id': usuarioId,
      'grupo_id': grupoId,
      'video_url': videoUrl,
      'fecha_ejercicio': fechaEjercicio.toIso8601String(),
    };
  }
}
