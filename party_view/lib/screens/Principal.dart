import 'package:flutter/material.dart';

import 'package:party_view/models/Sala.dart';
import 'package:party_view/services/GestorSalasService.dart';
import 'package:party_view/widget/CustomListView.dart';

class Principal extends StatefulWidget {
  Principal({super.key});

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  late Future<List<Sala>> _futureSalas;

  @override
  void initState() {
    super.initState();
    _futureSalas = GestorSalasService().getSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Sala>>(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/cineAnfitrion");
        },
        child: Icon(Icons.add),
      ),

      
    );
  }
}
