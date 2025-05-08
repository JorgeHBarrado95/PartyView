import 'package:flutter/material.dart';
import 'package:party_view/provider/SalaProvider.dart';
import 'package:party_view/provider/PersonaProvider.dart';
import 'package:party_view/screens/ReproduccionAnfitrion.dart';
import 'package:party_view/screens/SalaEspera.dart';
import 'package:party_view/screens/Login.dart';
import 'package:party_view/screens/Principal.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SalaProvider()),
        ChangeNotifierProvider(create: (_) => PersonaProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Ruta de la aplicación
      initialRoute: "/login",
      routes: {
        "/login": (context) => Login(),
        "/principal": (context) => Principal(),
        "/salaEspera": (context) => SalaEspera(),
        "/reproduccion": (context) => ReproduccionAnfitrion(),
      },
    );
  }
}
