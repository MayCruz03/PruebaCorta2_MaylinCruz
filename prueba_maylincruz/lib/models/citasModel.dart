import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  String id;
  DocumentReference pacienteId;
  DocumentReference doctorId;
  DateTime fechaHora;
  String motivo;
  String estado;

  Cita({
    required this.id,
    required this.pacienteId,
    required this.doctorId,
    required this.fechaHora,
    required this.motivo,
    required this.estado,
  });

  factory Cita.fromFirestore(DocumentSnapshot cita) {
    Map<String, dynamic> data = cita.data() as Map<String, dynamic>;
    return Cita(
      id: cita.id,
      pacienteId: data['pacienteId'] as DocumentReference,
      doctorId: data['doctorId'] as DocumentReference,
      fechaHora: (data['fecha'] as Timestamp).toDate(),
      motivo: data['motivo'] ?? '',
      estado: data['estado'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pacienteId': pacienteId,
      'doctorId': doctorId,
      'fecha': fechaHora,
      'motivo': motivo,
      'estado': estado,
    };
  }
}
