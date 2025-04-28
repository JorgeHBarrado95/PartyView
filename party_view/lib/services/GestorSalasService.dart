import "dart:convert";
import "dart:io";
import "dart:math";

import "package:http/http.dart" as http;
import "package:party_view/models/Persona.dart";
import "package:party_view/models/Sala.dart";
import "package:party_view/services/AuthService.dart";

/// Servicio que gestiona las operaciones relacionadas con las salas en la base de datos.
class GestorSalasService {
  /// URL base de la base de datos de Firebase.
  final String url =
      "https://partyview-8ba30-default-rtdb.europe-west1.firebasedatabase.app/Salas";

  /// Añade una sala a la base de datos.
  ///
  /// [sala] La sala que se desea añadir.
  /// Lanza una excepción si ocurre un error durante la operación.
  Future<void> addSala(Sala sala) async {
    final url = Uri.parse("${this.url}/${sala.id}.json");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sala.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add sala: ${response.body}");
    }

  }

<<<<<<< HEAD
  /// Comprueba si una sala con el ID especificado existe en la base de datos.
  ///
  /// [id] El ID de la sala a comprobar.
  /// Retorna el ID si no existe, o un objeto [Sala] si existe.
  Future<dynamic> comprobarSiExiste(String id) async {
=======
  Future<String> comprobarSiExiste(String id) async {
>>>>>>> parent of 3436d3f (EN pruebas)
    final url2 = Uri.parse("${this.url}/${id}.json");
    final response = await http.get(url2);

    if (response.body == "null") {
<<<<<<< HEAD
      // Si la respuesta es null, no existe la sala.
      return id;
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Sala.fromJson(id, data); // Convierte el JSON en un objeto Sala.
=======
      print("object");
      return id;
>>>>>>> parent of 3436d3f (EN pruebas)
    }
  }

  /// Obtiene todas las salas almacenadas en la base de datos.
  ///
  /// Retorna una lista de objetos [Sala].
  /// Lanza una excepción si ocurre un error durante la operación.
  Future<List<Sala>> getSalas() async {
    final url = Uri.parse("${this.url}.json");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Fallo al obtener salas: ${response.body}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<Sala> salas = [];

    data.forEach((key, value) {
      salas.add(Sala.fromJson(key, value));
    });

    return salas;
  }

  /// Elimina una sala de la base de datos.
  ///
  /// [id] El ID de la sala que se desea eliminar.
  /// Lanza una excepción si ocurre un error durante la operación.
  Future<void> removeSalas(String id) async {
    final url = Uri.parse("${this.url}/${id}.json");
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Fallo al eliminar sala: ${response.body}");
    }
  }

<<<<<<< HEAD
  /// Actualiza una sala en la base de datos.
  ///
  /// [sala] La sala que se desea actualizar.
  /// Actualmente, este método elimina la sala en lugar de actualizarla.
  Future<void> actualizarSala(Sala sala) async {
    final _url = Uri.parse("${this.url}/${sala.id}.json");
    final _response = await http.delete(_url);
  }

  /// Obtiene la lista de invitados de una sala específica.
  ///
  /// [id] El ID de la sala cuyos invitados se desean obtener.
  /// Retorna una lista de objetos [Persona].
  /// Lanza una excepción si ocurre un error durante la operación.
  Future<List<Persona>> obtenerInvitados(String id) async {
    final url = Uri.parse("${this.url}/${id}/invitados.json");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Fallo al obtener invitados: ${response.body}");
    }
    if (response.body == "null" || response.body.isEmpty) {
      // Si no hay invitados, devuelve una lista vacía.
      return [];
    }
    final List<dynamic> data = jsonDecode(response.body);
    final List<Persona> invitados =
        data.map((item) {
          return Persona.fromJson(item as Map<String, dynamic>);
        }).toList();

    return invitados;
  }
=======
  Future<void> actualizarSala(Sala sala) async{
    final _url = Uri.parse("${this.url}/${sala.id}.json");
    final _response = await http.delete(_url);  }
>>>>>>> parent of 3436d3f (EN pruebas)
}
