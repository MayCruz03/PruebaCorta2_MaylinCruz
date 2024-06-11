import 'package:flutter/material.dart';
import 'package:prueba_maylincruz/models/pacientesModel.dart';
import 'package:prueba_maylincruz/services/pacientesService.dart';

class PacientesScreen extends StatefulWidget {
  @override
  _PacientesScreenState createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final PacienteService _pacienteService = PacienteService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Gestión de Pacientes",
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
            _mostrarFormularioPaciente(context, null);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: StreamBuilder<List<Paciente>>(
          stream: _pacienteService.obtenerPacientes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay pacientes'));
            } else {
              final pacientes = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: pacientes.length,
                itemBuilder: (context, index) {
                  final paciente = pacientes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(paciente.fotoUrl),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  paciente.nombre,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Edad: ${paciente.edad}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _mostrarFormularioPaciente(context, paciente);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmarEliminar(context, paciente.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.details, color: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesPacienteScreen(
                                      paciente: paciente),
                                ),
                              );
                            },
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

  void _confirmarEliminar(BuildContext context, String pacienteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar este paciente?'),
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
                await _pacienteService.eliminarPaciente(pacienteId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioPaciente(BuildContext context, Paciente? paciente) {
    final TextEditingController nombreController = TextEditingController(
      text: paciente != null ? paciente.nombre : '',
    );
    final TextEditingController edadController = TextEditingController(
      text: paciente != null ? paciente.edad.toString() : '',
    );
    final TextEditingController fotoUrlController = TextEditingController(
      text: paciente != null ? paciente.fotoUrl : '',
    );
    final TextEditingController historialController = TextEditingController(
      text: paciente != null ? paciente.historial : '',
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
                  controller: edadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Edad',
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
                TextField(
                  controller: historialController,
                  decoration: InputDecoration(
                    labelText: 'Historial',
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
                        final nuevoPaciente = Paciente(
                          id: paciente != null ? paciente.id : '',
                          nombre: nombreController.text,
                          edad: int.parse(edadController.text),
                          fotoUrl: fotoUrlController.text,
                          historial: historialController.text,
                        );
                        if (paciente != null) {
                          await _pacienteService
                              .actualizarPaciente(nuevoPaciente);
                        } else {
                          await _pacienteService.agregarPaciente(nuevoPaciente);
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

class DetallesPacienteScreen extends StatelessWidget {
  final Paciente paciente;

  const DetallesPacienteScreen({Key? key, required this.paciente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Paciente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(paciente.fotoUrl),
            ),
            SizedBox(height: 16),
            Text(
              'Nombre: ${paciente.nombre}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Edad: ${paciente.edad}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Historial: ${paciente.historial}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
