import "dart:convert";
import "dart:math";

import "package:http/http.dart" as http;
import "package:party_view/models/Usuario.dart";
import "package:party_view/services/AuthService.dart";

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

  final urlNombre = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  Future<int> registro(Usuario usuario) async {
    final response = await http.post(
      urlRegister,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": usuario.email,
        "password": usuario.password,
        "returnSecureToken": true,
      }),
    );
    if (response.statusCode == 200) {
      //Registro ok
      //Actualizar el displayName
      final response2 = await http.post(
        urlUpdate,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": jsonDecode(response.body)["idToken"],
          "displayName": usuario.displayName,
          "returnSecureToken": true,
        }),
      );

      if (response2.statusCode == 200) {
        await Authservice().saveToken(jsonDecode(response.body)["idToken"]);
        await Authservice().saveDisplayName(usuario.displayName!);
        //Registro ok
        return 0;
      } else {
        //Error desconocido
        return 2;
      }
    } else if (response.statusCode == 400) {
      //El @ ya esta en uso
      return 3;
    } else {
      //Error desconocido
      return 2;
    }
  }

  Future<int> login(Usuario usuario) async {
    final response = await http.post(
      urlLogin,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": usuario.email,
        "password": usuario.password,
        "returnSecureToken": true,
      }),
    );
    if (response.statusCode == 400) {
      //Error en la contraseña o @
      return 1;
    } else if (response.statusCode == 200) {
      //Login ok
      await Authservice().saveDisplayName(
        //Guarda el nombre de user
        jsonDecode(response.body)["displayName"],
      );

      return 0;
    } else {
      //Error desconocido
      return 2;
    }
  }
}
