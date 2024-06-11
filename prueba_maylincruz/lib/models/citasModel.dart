import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  String id;
  String paciente;
  String doctor;
  DateTime fechaHora;
  String motivo;
  String estado;

  Cita({
    required this.id,
    required this.paciente,
    required this.doctor,
    required this.fechaHora,
    required this.motivo,
    required this.estado,
  });

  factory Cita.fromFirestore(DocumentSnapshot cita) {
    Map<String, dynamic> data = cita.data() as Map<String, dynamic>;
    return Cita(
      id: cita.id,
      paciente: data['pacienteId'] ?? '',
      doctor: data['doctorId'] ?? '',
      fechaHora: (data['fecha'] as Timestamp).toDate(),
      motivo: data['motivo'] ?? '',
      estado: data['estado'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pacienteId': paciente,
      'doctorId': doctor,
      'fecha': fechaHora,
      'motivo': motivo,
      'estado': estado,
    };
  }
}
