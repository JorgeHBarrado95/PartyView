import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:party_view/models/Anfitrion.dart';
import 'package:party_view/models/Sala.dart';
import 'package:party_view/provider/SalaProvider.dart';
import 'package:party_view/services/AuthService.dart';
import 'package:provider/provider.dart';

class GestorSalasService {
  final String url =
      "https://partyview-8ba30-default-rtdb.europe-west1.firebasedatabase.app/Salas";

  Future<void> addSala(Sala sala) async {
    final url = Uri.parse("${this.url}/${sala.id}.json");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sala.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add sala: ${response.body}");
      return;
    }

  }

  Future<String> comprobarSiExiste(String id) async {
    final url2 = Uri.parse("${this.url}/${id}.json");

    final response = await http.get(url2);

    //print(response.body);
    if (response.body == "null") {
      print("object");
      return id;
    }
    return "null";
  }

  Future<List<Sala>> getSalas() async {
    final url = Uri.parse("${this.url}.json");
    final response = await http.get(url);
    //final response = await http.get(url);

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

  Future<void> removeSalas(String id) async {
    final url = Uri.parse("${this.url}/${id}.json");
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Fallo al eliminar sala: ${response.body}");
    }
  }
}
