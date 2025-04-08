import "package:flutter/material.dart";
import "package:party_view/models/Persona.dart";

class ListViewInvitados extends StatelessWidget {
  const ListViewInvitados({super.key, required this.invitados});

  final List<Persona> invitados;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: invitados.length,
      itemBuilder: (context, index) {
        final invitado = invitados[index];
        return Card(
          margin: EdgeInsets.all(10), //Con las demas card
          child: Container(
            margin: EdgeInsets.all(10), //Con el borde del card
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Text(invitado.nombre[0]),
                  ), // Primera letra del nombre del invitado
                  title: Text("Invitado: #${invitado.ip}"),
                  subtitle: Text("Nombre: ${invitado.nombre}"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
