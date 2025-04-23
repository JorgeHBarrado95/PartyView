import "package:flutter/material.dart";
import "package:party_view/models/Persona.dart";
import "package:party_view/provider/SalaProvider.dart";
import "package:party_view/widget/CustomSnackBar.dart";
import "package:provider/provider.dart";

class ListViewInvitados extends StatelessWidget {
  const ListViewInvitados({super.key, required this.invitados});

  final List<Persona> invitados;

  @override
  Widget build(BuildContext context) {
    // Obtiene el proveedor de sala sin escuchar cambios
    final _salaProvider = Provider.of<SalaProvider>(context, listen: true);

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.person_remove),
                        onPressed: () {
                          _salaProvider.eliminarInvitado(invitado);

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              CustomSnackbar.info(
                                "!Se ha expulsado a ${invitado.nombre}!",
                                "",
                              ),
                            );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.block), // Bloquear persona de la sala
                        onPressed: () {
                          _salaProvider.bloquearPersona(invitado);

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              CustomSnackbar.info(
                                "!${invitado.nombre} ha sido bloqueado!",
                                "",
                              ),
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
