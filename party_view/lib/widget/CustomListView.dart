import 'package:flutter/material.dart';
import 'package:party_view/models/Sala.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({super.key, required this.salas});

  final List<Sala> salas;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: salas.length,
      itemBuilder: (context, index) {
        final sala = salas[index];
        return Card(
          margin: EdgeInsets.all(10), //Con las demas card
          child: Container(
            margin: EdgeInsets.all(10), //Con el borde del card
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Text(sala.anfitrion.nombre[0]),
                  ), // Primera letra del nombre del anfitrión
                  title: Text("Sala: #${sala.id}"),
                  subtitle: Text(
                    "Capacidad max: ${sala.capacidad}, Estado: ${sala.estado}",
                  ),
                  onTap:
                      () => print(
                        "Seleccionaste la sala de ${sala.anfitrion.nombre}",
                      ),
                ),
                Text("Anfitrión: ${sala.anfitrion.nombre}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
