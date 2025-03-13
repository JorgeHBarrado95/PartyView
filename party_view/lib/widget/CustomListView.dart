import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.nombres,
  });

  final List<String> nombres;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nombres.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(nombres[index][0]),
            ), // Primera letra del nombre
            title: Text(nombres[index]),
            subtitle: Text("Usuario número ${index + 1}"),
            trailing: Icon(Icons.favorite, color: Colors.red),
            onTap: () => print("Seleccionaste a ${nombres[index]}"),
          ),
        );
      },
    );
  }
}