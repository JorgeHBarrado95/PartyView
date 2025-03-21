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

    //print(response2.body);
  }

  Future<void> login(Usuario usuario) async {
    final response = await http.post(
      urlLogin,
      headers: {'Content-Type': 'application/json'},
      body: {
        "email": usuario.email,
        "password": usuario.password,
        "returnSecureToken": true,
      },
    );
    print(response.body);
  }
}
