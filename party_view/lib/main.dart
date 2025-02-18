import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:party_view/screens/Cine.dart';
import 'package:party_view/screens/Login.dart';
import 'package:party_view/screens/Principal.dart';
import 'package:party_view/screens/Sala.dart';

void main() async {
  runApp(MyApp());
  await tamanoMinVentana();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Party View",
      //Ruta de la aplicación
      initialRoute: "/principal",
      routes: {
        "/login": (context) => Login(),
        "/principal": (context) => Principal(),
        "/sala": (context) => Sala(),
        "/cine": (context) => Cine(),
      },
    );
  }
}

Future tamanoMinVentana() async {
  //Size size = await DesktopWindow.getWindowSize();
  //print(size); Sirve para saber el tamaño de la ventana
  await DesktopWindow.setMinWindowSize(Size(1280, 720));
}
