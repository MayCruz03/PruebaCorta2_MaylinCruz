import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<Paciente> obtenerPacientePorReferencia(
      DocumentReference referencia) async {
    // Obtener el ID del paciente desde la referencia
    String id = referencia.id;

    // Utilizar el método obtenerPacientePorId para obtener el paciente completo por su ID
    Paciente? paciente = await obtenerPacientePorId(id);

    // Retornar el paciente obtenido
    return paciente ??
        Paciente(id: '', nombre: '', edad: 0, fotoUrl: '', historial: '');
  }
}
