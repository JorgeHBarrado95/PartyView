import 'dart:io'; // Importa dart:io para usar Platform
import 'package:flutter/material.dart';
import 'package:party_view/screens/AndroidAnfitrion.dart';

class CineAnfitrion extends StatelessWidget {
  const CineAnfitrion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Platform.isAndroid ? Android() : Desktop());
  }
}

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("CINEEEE"));
  }
}
