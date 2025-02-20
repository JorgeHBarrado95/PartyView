import 'package:flutter/material.dart';

class Sala extends StatelessWidget {
  const Sala({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cineAnfitrion");
            },
            child: Text("Cine Anfitrión"),
          ),
          SizedBox(width: 20), // Añadir espacio entre los botones
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cineUsuario");
            },
            child: Text("Cine Usuario"),
          ),
        ],
      ),
    );
  }
}
