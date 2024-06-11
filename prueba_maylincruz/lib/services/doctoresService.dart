import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba_maylincruz/models/doctoresModel.dart';
import 'package:prueba_maylincruz/repositories/doctoresRepository.dart';

class DoctorService {
  final DoctorRepository _repository = DoctorRepository();

  Future<void> agregarDoctor(Doctor doctor) async {
    await _repository.agregarDoctor(doctor);
  }

  Stream<List<Doctor>> obtenerDoctores() {
    return _repository.obtenerDoctores();
  }

  Future<Doctor?> obtenerDoctorPorId(String id) async {
    return await _repository.obtenerDoctorPorId(id);
  }

  Future<void> actualizarDoctor(Doctor doctor) async {
    await _repository.actualizarDoctor(doctor);
  }

  Future<void> eliminarDoctor(String id) async {
    await _repository.eliminarDoctor(id);
  }

  Future<Doctor> obtenerDoctorPorReferencia(
      DocumentReference referencia) async {
    // Obtener el documento de Firestore utilizando la referencia
    DocumentSnapshot doctorSnapshot = await referencia.get();

    // Verificar si el documento existe
    if (doctorSnapshot.exists) {
      // Convertir el documento en un objeto Doctor utilizando el constructor fromFirestore
      Doctor doctor = Doctor.fromFirestore(doctorSnapshot);
      return doctor;
    } else {
      // Si el documento no existe, retornar un Doctor vacío o manejar de otra manera
      return Doctor(
          id: '',
          nombre: '',
          especialidad: '',
          disponibilidad: true,
          horario: '',
          fotoUrl: '');
    }
  }
}
