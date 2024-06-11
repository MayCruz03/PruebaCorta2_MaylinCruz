import 'package:flutter/material.dart';
import 'package:prueba_maylincruz/models/doctoresModel.dart';
import 'package:prueba_maylincruz/services/doctoresService.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final DoctorService _doctorService = DoctorService();
  String _filtroEspecialidad = 'Todos';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Gestión de Doctores",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 7, 120, 148),
          actions: [
            DropdownButton<String>(
              value: _filtroEspecialidad,
              icon: Icon(Icons.filter_list, color: Colors.white),
              dropdownColor: Color.fromARGB(255, 7, 120, 148),
              onChanged: (String? newValue) {
                setState(() {
                  _filtroEspecialidad = newValue!;
                });
              },
              items: <String>[
                'Todos',
                'Cardiología',
                'Pediatría',
                'Neurología',
                'Dermatología'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                );
              }).toList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 7, 120, 148),
          onPressed: () {
            _mostrarFormularioDoctor(context, null);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: StreamBuilder<List<Doctor>>(
          stream: _doctorService.obtenerDoctores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay doctores'));
            } else {
              final doctores = snapshot.data!;
              final doctoresFiltrados = _filtroEspecialidad == 'Todos'
                  ? doctores
                  : doctores
                      .where((doctor) =>
                          doctor.especialidad == _filtroEspecialidad)
                      .toList();
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: doctoresFiltrados.length,
                itemBuilder: (context, index) {
                  final doctor = doctoresFiltrados[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(doctor.fotoUrl),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.nombre,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Especialidad: ${doctor.especialidad}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Horario: ${doctor.horario}',
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
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        _mostrarFormularioDoctor(
                                            context, doctor);
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _confirmarEliminar(context, doctor.id);
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetallesDoctorScreen(
                                                    doctor: doctor),
                                          ),
                                        );
                                      },
                                      child: Text('Detalles'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  void _confirmarEliminar(BuildContext context, String doctorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar este doctor?'),
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
                await _doctorService.eliminarDoctor(doctorId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioDoctor(BuildContext context, Doctor? doctor) {
    final TextEditingController nombreController = TextEditingController(
      text: doctor != null ? doctor.nombre : '',
    );
    final TextEditingController especialidadController = TextEditingController(
      text: doctor != null ? doctor.especialidad : '',
    );
    final TextEditingController horarioController = TextEditingController(
      text: doctor != null ? doctor.horario : '',
    );
    final TextEditingController fotoUrlController = TextEditingController(
      text: doctor != null ? doctor.fotoUrl : '',
    );

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
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: especialidadController,
                  decoration: InputDecoration(
                    labelText: 'Especialidad',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: horarioController,
                  decoration: InputDecoration(
                    labelText: 'Horario',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: fotoUrlController,
                  decoration: InputDecoration(
                    labelText: 'Foto URL',
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
                        final nuevoDoctor = Doctor(
                          id: doctor != null ? doctor.id : '',
                          nombre: nombreController.text,
                          especialidad: especialidadController.text,
                          disponibilidad: true,
                          horario: horarioController.text,
                          fotoUrl: fotoUrlController.text,
                        );
                        if (doctor != null) {
                          await _doctorService.actualizarDoctor(nuevoDoctor);
                        } else {
                          await _doctorService.agregarDoctor(nuevoDoctor);
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
}

class DetallesDoctorScreen extends StatelessWidget {
  final Doctor doctor;

  const DetallesDoctorScreen({Key? key, required this.doctor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Doctor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(doctor.fotoUrl),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre: ${doctor.nombre}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Especialidad: ${doctor.especialidad}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Horario: ${doctor.horario}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
