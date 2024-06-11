import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pacientesModel.dart';

class PacienteRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> agregarPaciente(Paciente paciente) async {
    await _db.collection('tblPacientes').add(paciente.toFirestore());
  }

  Stream<List<Paciente>> obtenerPacientes() {
    return _db.collection('tblPacientes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Paciente.fromFirestore(doc)).toList());
  }

  Future<Paciente?> obtenerPacientePorId(String id) async {
    final doc = await _db.collection('tblPacientes').doc(id).get();
    if (doc.exists) {
      return Paciente.fromFirestore(doc);
    }
    return null;
  }

  Future<void> actualizarPaciente(Paciente paciente) async {
    await _db
        .collection('tblPacientes')
        .doc(paciente.id)
        .update(paciente.toFirestore());
  }

  Future<void> eliminarPaciente(String id) async {
    await _db.collection('tblPacientes').doc(id).delete();
  }
}
