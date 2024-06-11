import 'package:prueba_maylincruz/models/citasModel.dart';
import 'package:prueba_maylincruz/repositories/citasRepository.dart';

class CitaService {
  final CitaRepository _repository = CitaRepository();

  Future<void> agregarCita(Cita cita) async {
    await _repository.agregarCita(cita);
  }

  Stream<List<Cita>> obtenerCitas() {
    return _repository.obtenerCitas();
  }

  Future<Cita?> obtenerCitaPorId(String id) async {
    return await _repository.obtenerCitaPorId(id);
  }

  Future<void> actualizarCita(Cita cita) async {
    await _repository.actualizarCita(cita);
  }

  Future<void> eliminarCita(String id) async {
    await _repository.eliminarCita(id);
  }
}
