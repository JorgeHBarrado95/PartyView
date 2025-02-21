import 'dart:io'; // Importa dart:io para usar Platform
import 'package:flutter/material.dart';

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

class Android extends StatelessWidget {
  const Android({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("CINEEEE"));
  }
}

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("CINEEEE"));
  }
}
