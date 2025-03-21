import 'package:flutter/material.dart';

import 'package:party_view/models/Sala.dart';
import 'package:party_view/services/AuthService.dart';
import 'package:party_view/services/GestorSalasService.dart';
import 'package:party_view/widget/CustomListView.dart';

class Principal extends StatefulWidget {
  Principal({super.key});

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  late Future<List<Sala>> _futureSalas;
  final nombre = Authservice().getDisplayName();

  @override
  void initState() {
    super.initState();
    _futureSalas = GestorSalasService().getSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<Sala>>(
            future: _futureSalas,

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return Center(child: Text("No hay salas disponibles"));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error al cargar las salas"));
              } else {
                return CustomListView(salas: snapshot.data!);
              }
            },
          ),

          Text(nombre!),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/cineAnfitrion");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
