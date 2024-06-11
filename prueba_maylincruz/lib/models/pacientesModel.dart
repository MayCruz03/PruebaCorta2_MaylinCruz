import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  String id;
  String nombre;
  int edad;
  String fotoUrl;
  String historial;

  Paciente({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.fotoUrl,
    required this.historial,
  });

  factory Paciente.fromFirestore(DocumentSnapshot paciente) {
    Map<String, dynamic> data = paciente.data() as Map<String, dynamic>;
    return Paciente(
      id: paciente.id,
      nombre: data['nombre'] ?? '',
      edad: data['edad'] ?? 0,
      fotoUrl: data['fotoUrl'] ?? '',
      historial: data['historial'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'edad': edad,
      'fotoUrl': fotoUrl,
      'historial': historial,
    };
  }
}
