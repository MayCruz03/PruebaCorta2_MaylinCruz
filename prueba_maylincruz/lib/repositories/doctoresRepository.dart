import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctoresModel.dart';

class DoctorRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> agregarDoctor(Doctor doctor) async {
    await _db.collection('tblDoctores').add(doctor.toFirestore());
  }

  Stream<List<Doctor>> obtenerDoctores() {
    return _db.collection('tblDoctores').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList());
  }

  Future<Doctor?> obtenerDoctorPorId(String id) async {
    final doc = await _db.collection('tblDoctores').doc(id).get();
    if (doc.exists) {
      return Doctor.fromFirestore(doc);
    }
    return null;
  }

  Future<void> actualizarDoctor(Doctor doctor) async {
    await _db
        .collection('tblDoctores')
        .doc(doctor.id)
        .update(doctor.toFirestore());
  }

  Future<void> eliminarDoctor(String id) async {
    await _db.collection('tblDoctores').doc(id).delete();
  }
}
