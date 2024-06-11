import 'package:prueba_maylincruz/models/pacientesModel.dart';
import 'package:prueba_maylincruz/repositories/pacientesRepository.dart';

class PacienteService {
  final PacienteRepository _repository = PacienteRepository();

  Future<void> agregarPaciente(Paciente paciente) async {
    await _repository.agregarPaciente(paciente);
  }

  Stream<List<Paciente>> obtenerPacientes() {
    return _repository.obtenerPacientes();
  }

  Future<Paciente?> obtenerPacientePorId(String id) async {
    return await _repository.obtenerPacientePorId(id);
  }

  Future<void> actualizarPaciente(Paciente paciente) async {
    await _repository.actualizarPaciente(paciente);
  }

  Future<void> eliminarPaciente(String id) async {
    await _repository.eliminarPaciente(id);
  }
}
