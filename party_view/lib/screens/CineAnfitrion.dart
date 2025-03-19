import 'dart:io'; // Importa dart:io para usar Platform
import 'package:flutter/material.dart';
import 'package:party_view/models/Anfitrion.dart';
import 'package:party_view/models/Invitado.dart';
import 'package:party_view/models/Sala.dart';
import 'package:party_view/services/GestorSalasService.dart';

class CineAnfitrion extends StatelessWidget {
  const CineAnfitrion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body(), floatingActionButton: addSala(context));
  }

  FloatingActionButton addSala(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Crear una nueva salaS
        Sala nuevaSala = Sala(
          id: "0",
          capacidad: 5,
          video: true,
          estado: "abierto",
          anfitrion: Anfitrion(nombre: "Juan", ip: "555"),
          invitados: [Invitado(nombre: "a", ip: "dd")],
        );

        try {
          await GestorSalasService().addSala(nuevaSala);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Sala agregada exitosamente")));
        } catch (e) {
          print(e);
        }
      },
      child: Icon(Icons.add),
    );
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
