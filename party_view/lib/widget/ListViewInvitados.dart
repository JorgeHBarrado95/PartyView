import "package:flutter/material.dart";
import "package:party_view/models/Persona.dart";
import "package:party_view/provider/SalaProvider.dart";
import "package:party_view/widget/CustomSnackBar.dart";
import "package:provider/provider.dart";

class ListViewInvitados extends StatelessWidget {
  const ListViewInvitados({
    super.key,
    required this.invitados,
    required this.esAnfitrion,
  });

  final List<Persona> invitados;
  final bool esAnfitrion;

  @override
  Widget build(BuildContext context) {
    final _salaProvider = Provider.of<SalaProvider>(context, listen: true);

    return ListView.builder(
      itemCount: invitados.length,
      itemBuilder: (context, index) {
        final invitado = invitados[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(child: Text(invitado.nombre[0])),
                  title: Text("Invitado: #${invitado.ip}"),
                  subtitle: Text("Nombre: ${invitado.nombre}"),
                  trailing:
                      esAnfitrion
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.person_remove),
                                onPressed: () async {
                                  await _salaProvider.eliminarInvitado(
                                    invitado,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        CustomSnackbar.info(
                                          "!Se ha expulsado a ${invitado.nombre}!",
                                          "",
                                        ),
                                      );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.block),
                                onPressed: () async {
                                  await _salaProvider.bloquearPersona(invitado);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        CustomSnackbar.info(
                                          "!${invitado.nombre} ha sido bloqueado!",
                                          "",
                                        ),
                                      );
                                  }
                                },
                              ),
                            ],
                          )
                          : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
