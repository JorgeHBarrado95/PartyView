import 'package:party_view/provider/PersonaProvider.dart';
import 'package:party_view/widget/ListViewInvitados.dart';
import 'package:provider/provider.dart';
import 'package:party_view/services/GestorSalasService.dart';
import 'package:party_view/services/AuthService.dart';
import 'package:party_view/models/Sala.dart';
import 'package:party_view/provider/SalaProvider.dart';
import 'package:flutter/material.dart';
import 'package:party_view/models/Persona.dart';
import 'dart:io';

class SalaEspera extends StatefulWidget {
  const SalaEspera({super.key});
  @override
  _SalaEsperaState createState() => _SalaEsperaState();
}

class _SalaEsperaState extends State<SalaEspera> {
  late SalaProvider salaProvider;
  late PersonaProvider personaProvider;
  bool _inicializado = false;
  bool _esAnfitrion = false;
  Sala? _sala;
  @override
  ///Llama a didChangeDependencies cuando el widget se inserta en el árbol de widgets.
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _esAnfitrion = (args is Map<String, dynamic>) ? args["esAnfitrion"] : false;
    _sala = args["sala"];

    if (!_inicializado) {
      salaProvider = Provider.of<SalaProvider>(context, listen: true);
      personaProvider = Provider.of<PersonaProvider>(context, listen: false);
      _onScreenOpened();

      ///Detecta cuando se abre la ventana por primera vez[_inicializado].
      _inicializado = true;
    }
  }

  Future<void> _onScreenOpened() async {
    if (_esAnfitrion) {
      await salaProvider.crearSala(personaProvider.getPersona!);
      await GestorSalasService().addSala(salaProvider.sala!);
    } else {
      Future.delayed(Duration.zero, () {
        //Uso el future delayed para que no me de error de null
        salaProvider.setSala(_sala!);
      });
    }
    salaProvider.iniciarTimer();
  }

  @override
  ///Detecta cuando se cierra la ventana y llama a el metodo [_onScreenClosed].
  ///Llama a super.dispose() para asegurarse de que se liberen los recursos utilizados por el widget.
  void dispose() {
    _onScreenClosed();
    super.dispose();
  }

  ///Usa el el metodo [removeSalas] para eliminar la sala de la base de datos.
  void _onScreenClosed() {
    if (_esAnfitrion) {
      GestorSalasService().removeSalas(salaProvider.sala!.id);
    } else {
      salaProvider.eliminarInvitado(
        personaProvider.getPersona!,
      ); //Por algun motivo el proveeder es null
    }
    salaProvider.detenerTimer();
  }

  @override
  Widget build(BuildContext context) {
    ///Boton de salida
    return Scaffold(
      body: Body(esAnfitrion: _esAnfitrion),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key, required this.esAnfitrion});

  final bool esAnfitrion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [MenuArriba(esAnfitrion: esAnfitrion), SizedBox(height: 20), ListaInvitados(esAnfitrion: esAnfitrion)],
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        margin: EdgeInsets.all(30),
      ),
    );
  }
}

///List View de los invitados.
class ListaInvitados extends StatelessWidget {
  const ListaInvitados({super.key, required this.esAnfitrion});

  final bool esAnfitrion;

  @override
  Widget build(BuildContext context) {
    final _salaProvider = Provider.of<SalaProvider>(context, listen: true);
    final invitados =
        _salaProvider.sala?.invitados ?? []; //Si esta vacío el array, devuelve una lista vacía.

    if (invitados.isEmpty) {
      return Center(child: Text("No hay invitados disponibles"));
    }

    return Expanded(
      child: ListViewInvitados(
        invitados: invitados,
        esAnfitrion: esAnfitrion,
      ),
    );
  }
}

///El [menuArriba] es el menu de la parte superior de la pantalla donde aparece el id, la capacidad y el estado de la sala.
class MenuArriba extends StatefulWidget {
  const MenuArriba({super.key, required this.esAnfitrion});

  final bool esAnfitrion;

  @override
  _MenuArribaState createState() => _MenuArribaState();
}

class _MenuArribaState extends State<MenuArriba> {
  Sala? sala;
  String _selectedEstado = "Abierto";
  final List<String> _estados = ["Abierto", "Cerrado"];

  @override
  Widget build(BuildContext context) {
    final _salaProvider = Provider.of<SalaProvider>(context);
    final _sala = _salaProvider.sala;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _sala != null ? "Sala: #${_sala.id}" : "Cargando sala...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
              Row(
                children: [
                  Text(() {
                    try {
                      return "Capacidad: ${_sala!.capacidad}";
                    } catch (e) {
                      return "Capacidad no disponible";
                    }
                  }(), style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  if (widget.esAnfitrion) //Se pone widget para acceder a la variable de la clase padre
                    ElevatedButton(
                      onPressed: () {
                        _salaProvider.incrementarCapacidad();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Icon(Icons.add, size: 20),
                    ),
                  if (widget.esAnfitrion)
                    ElevatedButton(
                      onPressed: () {
                        _salaProvider.disminuirCapacidad();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Icon(Icons.remove, size: 20),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Estado de la sala:", style: TextStyle(fontSize: 16)),
              SizedBox(width: 15),
              DropdownButton<String>(
                value: _selectedEstado,
                items: _estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: widget.esAnfitrion
                    ? (String? newValue) {
                        setState(() {
                          _selectedEstado = newValue!;
                          _salaProvider.estado(_selectedEstado);
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
