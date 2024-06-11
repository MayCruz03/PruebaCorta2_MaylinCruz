import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String id;
  String nombre;
  String especialidad;
  bool disponibilidad;
  String horario;
  String fotoUrl;

  Doctor({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.disponibilidad,
    required this.horario,
    required this.fotoUrl,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doctor) {
    Map<String, dynamic> data = doctor.data() as Map<String, dynamic>;
    return Doctor(
      id: doctor.id,
      nombre: data['nombre'] ?? '',
      especialidad: data['especialidad'] ?? '',
      disponibilidad: data['disponibilidad'] ?? true,
      horario: data['horario'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'especialidad': especialidad,
      'disponibilidad': disponibilidad,
      'horario': horario,
      'fotoUrl': fotoUrl,
    };
  }
}
