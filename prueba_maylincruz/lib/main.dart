import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_maylincruz/firebase_options.dart';
import 'package:prueba_maylincruz/screens/crearUsuario.dart';
import 'package:prueba_maylincruz/screens/crud_citas.dart';
import 'package:prueba_maylincruz/screens/crud_doctores.dart';
import 'package:prueba_maylincruz/screens/crud_pacientes.dart';
import 'package:prueba_maylincruz/screens/principal.dart';
import 'package:prueba_maylincruz/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/LoginPage',
    routes: [
      GoRoute(
        path: '/LoginPage',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/Doctores',
        builder: (context, state) => DoctorScreen(),
      ),
      GoRoute(
        path: '/Pacientes',
        builder: (context, state) => PacientesScreen(),
      ),
      GoRoute(
        path: '/Citas',
        builder: (context, state) => CitasScreen(),
      ),
      GoRoute(
        path: '/Usuario',
        builder: (context, state) => CreateUserPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          final nombreUsuario = state.extra as String?;
          return MyHomePage(nombreUsuario: nombreUsuario ?? 'fullName');
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
