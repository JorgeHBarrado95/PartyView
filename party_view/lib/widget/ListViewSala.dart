<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 0c0dd42 (Revert "EN pruebas")
import "package:audioplayers/audioplayers.dart";
>>>>>>> 0f9a673 (Conexion Sala)
import "package:awesome_snackbar_content/awesome_snackbar_content.dart";
=======
>>>>>>> parent of 3436d3f (EN pruebas)
import "package:flutter/material.dart";
import "package:party_view/models/Sala.dart";

class ListViewSala extends StatelessWidget {
  const ListViewSala({super.key, required this.salas});

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
<<<<<<< HEAD

<<<<<<< HEAD
  void conectarSala(BuildContext context, Sala sala) {
    final _salaProvider = Provider.of<SalaProvider>(context, listen: false);
    //final player = AudioPlayer();
=======
  //Cuando el usuario hace click en la sala, comprueba q exista, comprueba si hay sitio y si hay se añade a la sala (Modifica la bd)
  //Si no hay sitio, muestra un snackbar
  void conectarSala(BuildContext context, Sala sala) {
    final _salaProvider = Provider.of<SalaProvider>(context, listen: false);
>>>>>>> 0f9a673 (Conexion Sala)
    _salaProvider.setSala(sala);

    GestorSalasService _gestorSalasService = GestorSalasService();
    _gestorSalasService
        .comprobarSiExiste(sala.id)
        .then((value) async {
          //print(value);
          if (value.id == sala.id) {
            if (_salaProvider.sala!.estado == "Abierto") {
              Persona _persona = Persona(
                //Crea el invitado
                nombre: Authservice().getDisplayName() ?? "Desconocido",
                ip: await _salaProvider.getIpAddress(),
              );

              // Verifica que la persona NO esté en la lista de bloqueados
              if (_salaProvider.sala!.bloqueados
                  .where(
                    (persona) =>
                        persona.ip == _persona.ip &&
                        persona.nombre == _persona.nombre,
                  )
                  .isEmpty) {
                if (_salaProvider.sala!.invitados.length < //Limite de invitados
                    _salaProvider.sala!.capacidad) {
                  //print("conectado y hay sitio");
                  Navigator.pushNamed(context, "/cineInvitado");

                  sala.invitados.add(_persona); //Añade el invitado a la sala

                  _gestorSalasService //Modifica la sala en la bd
                      .addSala(sala)
                      .then((value) {
                        print("Añadido a la sala");
                      })
                      .catchError((error) async {
                        print("Error al añadir a la sala: $error");

<<<<<<< HEAD
<<<<<<< HEAD
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.aprobacion(
                          "Error",
                          "Error al meterte en la sala",
                        ),
                      );
<<<<<<< HEAD
                    //await player.play(AssetSource("sounds/notification.mp3"));

=======
>>>>>>> 0f9a673 (Conexion Sala)
                  });
            } else {
=======
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          CustomSnackbar.aprobacion(
                            "Error",
                            "Error al meterte en la sala",
                          ),
                        );
                    });
=======
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            CustomSnackbar.aprobacion(
                              "Error",
                              "Error al meterte en la sala",
                            ),
                          );
                      });
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      CustomSnackbar.error(
                        "¡Error!",
                        "La sala está llena tete!!!!!!",
                      ),
                    );
                }
>>>>>>> 5adf228 (Expulsión y bloqueo)
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    CustomSnackbar.error(
                      "¡Error!",
                      "No puedes entrar a la sala, estás bloqueado.",
                    ),
                  );
              }
<<<<<<< HEAD
            }else{
>>>>>>> 722d3ca (Fix Cerrado/Abierto Sala)
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  CustomSnackbar.error(
                    "¡Error!",
<<<<<<< HEAD
                    "La sala está llena tete!!!!!!",
<<<<<<< HEAD
                  ),
=======
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  CustomSnackbar.error("¡Error!", "La sala está cerrada."),
>>>>>>> 5adf228 (Expulsión y bloqueo)
                );
              //await player.play(AssetSource("sounds/notification.mp3"));
=======
                  ) as SnackBar,
=======
                    "La sala está cerrada.",
                  ),
>>>>>>> 722d3ca (Fix Cerrado/Abierto Sala)
                );
>>>>>>> 0f9a673 (Conexion Sala)
            }
          }
        })
        .catchError((error) async {
          print(error);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              CustomSnackbar.error(
<<<<<<< HEAD
                "¡Error!",
                "Algo salió mal al realizar la acción.",
<<<<<<< HEAD
              ),
            );
          //await player.play(AssetSource("sounds/notification.mp3"));
=======
              ) as SnackBar,
=======
                    "¡Error!",
                    "Algo salió mal al realizar la acción.",
<<<<<<< HEAD
                  )
                  as SnackBar,
>>>>>>> 722d3ca (Fix Cerrado/Abierto Sala)
=======
                  ),
>>>>>>> 5adf228 (Expulsión y bloqueo)
            );
>>>>>>> 0f9a673 (Conexion Sala)
        });
  }
=======
>>>>>>> parent of 3436d3f (EN pruebas)
}
