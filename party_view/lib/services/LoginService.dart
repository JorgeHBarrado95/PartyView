import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:party_view/models/Usuario.dart';

class Loginservice {
  final urlRegister = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  final urlLogin = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  final urlUpdate = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  Future<void> registro(Usuario usuario) async {
    final response = await http.post(
      urlRegister,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": usuario.email,
        "password": usuario.password,
        "returnSecureToken": true,
      }),
    );
    if (response.statusCode == 200) {
      print("Registro ok");
    } else {
      print("Error en el registro");
    }
    //print(response.body);

    //Actualizar el displayName
    final response2 = await http.post(
      urlUpdate,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "idToken": jsonDecode(response.body)["idToken"],
        "displayName": usuario.displayName,
        "returnSecureToken": true,
      }),
    );

    if (response.statusCode == 200) {
      print("Registro del nombre ok");
    } else {
      print("Error en el registro");
    }

    //print(response2.body);
  }

  Future<void> login(Usuario usuario) async {
    final response = await http.post(
      urlLogin,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": usuario.email,
        "password": usuario.password,
        "returnSecureToken": true,
      }),
    );
    print("------------------");
    if (response.statusCode == 400) {
      print("Error en la contraseña");
    } else if (response.statusCode == 200) {
      print("Usuario logeado");
    } else {
      print("Error desconocido");
    }
  }
}
