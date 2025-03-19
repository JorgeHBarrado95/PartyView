import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:party_view/models/Sala.dart';

class GestorSalasService {
  final String url =
      "https://partyview-8ba30-default-rtdb.europe-west1.firebasedatabase.app/Salas.json";

  Future<void> addSala(Sala sala) async {
    final url = Uri.parse(this.url);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sala.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add sala: ${response.body}');
    }
  }

  Future<List<Sala>> getSalas() async {
    final url = Uri.parse(this.url);
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Fallo al obtener salas: ${response.body}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<Sala> salas = [];

    data.forEach((key, value) {
      salas.add(Sala.fromJson(key, value));
    });

    return salas;
  }
}
