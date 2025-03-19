import 'package:flutter/material.dart';
import 'package:party_view/models/Anfitrion.dart';
import 'package:party_view/models/Invitado.dart';
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
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las salas'));
          } else {
            return CustomListView(salas: snapshot.data!);
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Crear una nueva salaS
          Sala nuevaSala = Sala(

            capacidad: 5,
            video: true,
            estado: 'abierto',
            anfitrion: Anfitrion(nombre: 'Juan', ip: '555'),
            invitados: [Invitado(nombre: 'a', ip: 'dd')],
          );

          try {
            await GestorSalasService().addSala(nuevaSala);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sala agregada exitosamente')),
            );
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
