import 'package:flutter/material.dart';
import 'package:party_view/widget/CustomListView.dart';

class Principal extends StatelessWidget {
  Principal({super.key});
  final List<String> nombres = ["Juan", "María", "Carlos", "Ana", "Luis"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomListView(nombres: nombres),
    );
  }
}


