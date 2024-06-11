import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_maylincruz/screens/crud_citas.dart';
import 'package:prueba_maylincruz/screens/crud_doctores.dart';
import 'package:prueba_maylincruz/screens/crud_pacientes.dart';

class MyHomePage extends StatelessWidget {
  final String nombreUsuario;

  MyHomePage({required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menú Principal"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.go('/LoginPage');
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 7, 120, 148),
              Color.fromARGB(255, 25, 25, 112),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido, $nombreUsuario',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/Doctores');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.people, color: Color.fromARGB(255, 7, 120, 148)),
              label: Text(
                'Gestión de Doctores',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 7, 120, 148)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/Pacientes');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.people, color: Color.fromARGB(255, 7, 120, 148)),
              label: Text(
                'Gestión de Pacientes',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 7, 120, 148)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/Citas');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.people, color: Color.fromARGB(255, 7, 120, 148)),
              label: Text(
                'Gestión de Citas',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 7, 120, 148)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
