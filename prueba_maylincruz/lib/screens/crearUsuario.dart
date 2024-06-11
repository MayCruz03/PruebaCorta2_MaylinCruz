import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String fullName = _fullNameController.text.trim();
      final String age = _ageController.text.trim();
      final Timestamp fechaCreacion = Timestamp.now();

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'fullName': fullName,
        'age': age,
        'fecha_creacion': fechaCreacion,
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('Usuario creado con éxito'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/LoginPage');
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              e.message ?? 'Ocurrió un error al intentar crear el usuario.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createUserWithEmailAndPassword,
              child: Text('Crear Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
