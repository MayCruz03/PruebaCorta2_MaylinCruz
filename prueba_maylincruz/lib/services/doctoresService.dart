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
}
