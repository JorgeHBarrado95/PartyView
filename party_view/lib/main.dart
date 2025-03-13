import 'package:flutter/material.dart';
import 'package:party_view/screens/CineAnfitrion.dart';
import 'package:party_view/screens/CineUsuario.dart';
import 'package:party_view/screens/Login.dart';
import 'package:party_view/screens/Principal.dart';
import 'package:party_view/screens/Sala.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Ruta de la aplicación
      initialRoute: "/principal",
      routes: {
        "/login": (context) => Login(),
        "/principal": (context) => Principal(),
        "/sala": (context) => Sala(),
        "/cineAnfitrion": (context) => CineAnfitrion(),
        "/cineUsuario": (context) => CineUsuario(),
      },
    );
  }
}
