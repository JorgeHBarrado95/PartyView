import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:party_view/models/Sala.dart';

class GestorSalasService {
  final String url =
      "https://partyview-8ba30-default-rtdb.europe-west1.firebasedatabase.app/Salas";

  Future<void> addSala(Sala sala) async {
    String idSala = await idSalaComp();
    sala.id = idSala;
    final url = Uri.parse("${this.url}/${idSala}.json");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sala.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add sala: ${response.body}');
    }
  }

  //Genera un id rand pa la sala y comprueba q existe
  Future<String> idSalaComp() async {
    final random = Random();
    while (true) {
      int randId = random.nextInt(100000);
      //print(randId);

      String randIdString = randId.toString().padLeft(5, "0"); //Se añaden 0 para q simpre sean 5 digitos

      final url2 = Uri.parse("${this.url}/${randIdString}.json");

      final response = await http.get(url2);

      //print(response.body);
      if (response.body == "null") {
        return randIdString;
      }
    }
  }

  Future<List<Sala>> getSalas() async {
    final url = Uri.parse(this.url);
    final response = await http.get(Uri.parse("${url}.json"));
    //final response = await http.get(url);

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
