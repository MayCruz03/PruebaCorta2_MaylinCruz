import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba_maylincruz/models/citasModel.dart';
import 'package:prueba_maylincruz/models/doctoresModel.dart';
import 'package:prueba_maylincruz/models/pacientesModel.dart';
import 'package:prueba_maylincruz/services/citasServices.dart';
import 'package:prueba_maylincruz/services/doctoresService.dart';
import 'package:prueba_maylincruz/services/pacientesService.dart';

class CitasScreen extends StatefulWidget {
  @override
  _CitasScreenState createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final CitaService _citaService = CitaService();
  final DoctorService _doctorService = DoctorService();
  final PacienteService _pacienteService = PacienteService();
  late List<Doctor> _doctores;
  late List<Paciente> _pacientes;
  late String _selectedDoctorId;
  late String _selectedPacienteId;

  @override
  void initState() {
    super.initState();
    _doctores = [];
    _pacientes = [];
    _selectedDoctorId = '';
    _selectedPacienteId = '';
    _loadData();
  }

  Future<void> _loadData() async {
    final List<Doctor> doctores = await _doctorService.obtenerDoctores().first;
    final List<Paciente> pacientes =
        await _pacienteService.obtenerPacientes().first;
    setState(() {
      _doctores = doctores;
      _pacientes = pacientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Gestión de Citas",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 7, 120, 148),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 7, 120, 148),
          onPressed: () {
            _mostrarFormularioCita(context, null);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: StreamBuilder<List<Cita>>(
          stream: _citaService.obtenerCitas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay citas'));
            } else {
              final citas = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: citas.length,
                itemBuilder: (context, index) {
                  final cita = citas[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Doctor>(
                            future: _doctorService
                                .obtenerDoctorPorReferencia(cita.doctorId),
                            builder: (context, doctorSnapshot) {
                              if (doctorSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (doctorSnapshot.hasError) {
                                return Text('Error al cargar el doctor');
                              } else if (!doctorSnapshot.hasData) {
                                return Text('Doctor no encontrado');
                              } else {
                                final doctor = doctorSnapshot.data!;
                                return Text(
                                  'Doctor: ${doctor.nombre}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 4),
                          FutureBuilder<Paciente>(
                            future: _pacienteService
                                .obtenerPacientePorReferencia(cita.pacienteId),
                            builder: (context, pacienteSnapshot) {
                              if (pacienteSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (pacienteSnapshot.hasError) {
                                return Text('Error al cargar el paciente');
                              } else if (!pacienteSnapshot.hasData) {
                                return Text('Paciente no encontrado');
                              } else {
                                final paciente = pacienteSnapshot.data!;
                                return Text(
                                  'Paciente: ${paciente.nombre}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fecha y Hora: ${DateFormat('yyyy-MM-dd HH:mm').format(cita.fechaHora)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Motivo: ${cita.motivo}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Estado: ${cita.estado}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _mostrarFormularioCita(context, cita);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmarEliminar(context, cita.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.details, color: Colors.green),
                                onPressed: () {
                                  _verDetalles(context, cita);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, String citaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar esta cita?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                await _citaService.eliminarCita(citaId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioCita(BuildContext context, Cita? cita) {
    final TextEditingController motivoController = TextEditingController(
      text: cita != null ? cita.motivo : '',
    );
    String estado = cita != null ? cita.estado : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedDoctorId.isNotEmpty
                      ? _selectedDoctorId
                      : cita?.doctorId.id,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDoctorId = newValue!;
                    });
                  },
                  items: _doctores.map((Doctor doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.id,
                      child: Text(doctor.nombre),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Doctor',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPacienteId.isNotEmpty
                      ? _selectedPacienteId
                      : cita?.pacienteId.id,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPacienteId = newValue!;
                    });
                  },
                  items: _pacientes.map((Paciente paciente) {
                    return DropdownMenuItem<String>(
                      value: paciente.id,
                      child: Text(paciente.nombre),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Paciente',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: motivoController,
                  decoration: InputDecoration(
                    labelText: 'Motivo',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd HH:mm')
                        .format(cita?.fechaHora ?? DateTime.now()),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Fecha y Hora',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: estado),
                  onChanged: (value) {
                    setState(() {
                      estado = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Guardar'),
                      onPressed: () async {
                        final nuevaCita = Cita(
                          id: cita?.id ?? '',
                          pacienteId: FirebaseFirestore.instance
                              .doc('pacientes/$_selectedPacienteId'),
                          doctorId: FirebaseFirestore.instance
                              .doc('doctores/$_selectedDoctorId'),
                          fechaHora: cita?.fechaHora ?? DateTime.now(),
                          motivo: motivoController.text,
                          estado: estado,
                        );
                        if (cita != null) {
                          await _citaService.actualizarCita(nuevaCita);
                        } else {
                          await _citaService.agregarCita(nuevaCita);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verDetalles(BuildContext context, Cita cita) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Cita'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: cita.doctorId.get(),
                  builder: (context, doctorSnapshot) {
                    if (doctorSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (doctorSnapshot.hasError) {
                      return Text('Error al cargar el doctor');
                    } else {
                      final doctorData =
                          doctorSnapshot.data!.data() as Map<String, dynamic>?;
                      final doctorNombre =
                          doctorData?['nombre'] ?? 'Nombre no disponible';
                      return Text('Doctor: $doctorNombre');
                    }
                  },
                ),
                SizedBox(height: 8),
                FutureBuilder<DocumentSnapshot>(
                  future: cita.pacienteId.get(),
                  builder: (context, pacienteSnapshot) {
                    if (pacienteSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (pacienteSnapshot.hasError) {
                      return Text('Error al cargar el paciente');
                    } else {
                      final pacienteData = pacienteSnapshot.data!.data()
                          as Map<String, dynamic>?;
                      final pacienteNombre =
                          pacienteData?['nombre'] ?? 'Nombre no disponible';
                      return Text('Paciente: $pacienteNombre');
                    }
                  },
                ),
                SizedBox(height: 8),
                Text(
                    'Fecha y Hora: ${DateFormat('yyyy-MM-dd HH:mm').format(cita.fechaHora)}'),
                SizedBox(height: 8),
                Text('Motivo: ${cita.motivo}'),
                SizedBox(height: 8),
                Text('Estado: ${cita.estado}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
