import 'dart:io'; // Importa dart:io para usar Platform
import 'package:flutter/material.dart';
import 'package:party_view/models/Anfitrion.dart';
import 'package:party_view/models/Invitado.dart';
import 'package:party_view/models/Sala.dart';
import 'package:party_view/services/GestorSalasService.dart';

class CineAnfitrion extends StatefulWidget {
  const CineAnfitrion({super.key});

  @override
  _CineAnfitrionState createState() => _CineAnfitrionState();
}

class _CineAnfitrionState extends State<CineAnfitrion> {
  @override
  void initState() {
    super.initState();
    _onScreenOpened(); //Detecta cuando se abre la ventana
  }

  Future<void> _onScreenOpened() async {
    await GestorSalasService().addSala();
  }

  @override
  void dispose() {
    _onScreenClosed(); // Llama al método cuando se cierra la pantalla
    super.dispose();
  }

  void _onScreenClosed() {
    GestorSalasService().removeSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("atras"),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [MenuArriba(), SizedBox(height: 20), ListaInvitados()],
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

class ListaInvitados extends StatelessWidget {
  const ListaInvitados({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Lista de invitados"));
  }
}

class MenuArriba extends StatefulWidget {
  const MenuArriba({super.key});

  @override
  _MenuArribaState createState() => _MenuArribaState();
}

class _MenuArribaState extends State<MenuArriba> {
  Sala? sala;
  String _selectedEstado = "Abierto";
  final List<String> _estados = ["Abierto", "Cerrado"];

  void initState() {
    super.initState();
    _cargarSala();
  }

  Future<void> _cargarSala() async {
    try {
      Sala? salaNew = await Authservice().getSala();
      setState(() {
        sala = salaNew;
        //print(sala!.id);
      });
    } catch (e) {
      print("Error al cargar la sala");
    }

    sala = await Authservice().getSala();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sala != null ? "Sala: #${sala!.id}" : "Cargando sala...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
              Row(
                children: [
                  Text("Capacidad: 5", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      print("Incrementar capacidad");
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Icon(Icons.add, size: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Reducir capacidad");
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
                items:
                    _estados.map((String estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEstado = newValue!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
