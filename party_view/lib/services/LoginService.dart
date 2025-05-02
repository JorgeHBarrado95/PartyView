import "dart:convert";
import "package:http/http.dart" as http;
import "package:party_view/models/Usuario.dart";
import "package:party_view/provider/PersonaProvider.dart";
import "package:party_view/services/AuthService.dart";


/// Servicio que gestiona el registro y login de usuarios utilizando Firebase Authentication, enviando y recibiendo peticiones HTTP.
class Loginservice {
  final PersonaProvider personaProvider;

  Loginservice(this.personaProvider);

  /// URL para registrar un nuevo usuario.
  final urlRegister = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  /// URL para iniciar sesión con un usuario existente.
  final urlLogin = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  /// URL para actualizar información del usuario, como el nombre de usuario.
  final urlUpdate = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  /// URL para obtener información del usuario, como el nombre de usuario.
  final urlNombre = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCR6r9ZgSdyXUYWmQOzATl2MQYW8EASsoE",
  );

  /// Registra un nuevo usuario en Firebase Authentication.
  ///
  /// [usuario] El objeto [Usuario] que contiene el email, contraseña y nombre de usuario.
  /// Retorna:
  /// - `0` si el registro fue exitoso.
  /// - `2` si ocurrió un error desconocido.
  /// - `3` si el correo electrónico ya está en uso.
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
      // Registro exitoso, actualiza el displayName.
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
        await personaProvider.crearPersona(usuario.displayName!);
        return 0; // Registro exitoso.
      } else {
        return 2; // Error desconocido.
      }
    } else if (response.statusCode == 400) {
      return 3; // El correo electrónico ya está en uso.
    } else {
      return 2; // Error desconocido.
    }
  }

  /// Inicia sesión con un usuario existente en Firebase Authentication.
  ///
  /// [usuario] El objeto [Usuario] que contiene el email y contraseña.
  /// Retorna:
  /// - `0` si el inicio de sesión fue exitoso.
  /// - `1` si hay un error en la contraseña o correo electrónico.
  /// - `2` si ocurrió un error desconocido.
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

    //print("Response status: ${response.statusCode}");
    //print("Response body: ${response.body}");

    if (response.statusCode == 400) {
      print("Error: Contraseña o correo incorrecto");
      return 1; // Error en la contraseña o correo electrónico.
    } else if (response.statusCode == 200) {
      print("Inicio de sesión exitoso");

      // Actualiza el displayName del usuario con el valor recibido del servidor.
      final responseData = jsonDecode(response.body);
      usuario.displayName = responseData["displayName"];

      // Usa el provider inyectado.
      await personaProvider.crearPersona(usuario.displayName!);
      //print(personaProvider.getPersona.toString());
      return 0; // Inicio de sesión exitoso.
    } else {
      print("Error desconocido");
      return 2; // Error desconocido.
    }
  }
}
