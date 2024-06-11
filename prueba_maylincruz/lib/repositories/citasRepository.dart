import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/citasModel.dart';

class CitaRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> agregarCita(Cita cita) async {
    await _db.collection('tblCitas').add(cita.toFirestore());
  }

  Stream<List<Cita>> obtenerCitas() {
    return _db.collection('tblCitas').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Cita.fromFirestore(doc)).toList());
  }

  Future<Cita?> obtenerCitaPorId(String id) async {
    final doc = await _db.collection('tblCitas').doc(id).get();
    if (doc.exists) {
      return Cita.fromFirestore(doc);
    }
    return null;
  }

  Future<void> actualizarCita(Cita cita) async {
    await _db.collection('tblCitas').doc(cita.id).update(cita.toFirestore());
  }

  Future<void> eliminarCita(String id) async {
    await _db.collection('tblCitas').doc(id).delete();
  }
}
