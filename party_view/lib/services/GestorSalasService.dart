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

  Future<void> addSala(BuildContext context) async {
    //Creo objeto sala
    Sala sala = Sala(
      id: await idSalaComp(),
      capacidad: 5,
      video: true,
      estado: "abierto",
      anfitrion: Anfitrion(
        nombre: Authservice().getDisplayName() ?? "Desconocido",
        ip: await getIpAddress(),
      ),
      invitados: [],
    );

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

    if (response.statusCode == 200) {
      Provider.of<SalaProvider>(context, listen: false).setSala(sala);
      return;
    }

    throw Exception("Unexpected error in addSala");
  }

  //Genera un id rand pa la sala y comprueba q existe
  Future<String> idSalaComp() async {
    final random = Random();
    while (true) {
      int randId = random.nextInt(100000);
      //print(randId);

      String randIdString = randId.toString().padLeft(
        5,
        "0",
      ); //Se añaden 0 para q simpre sean 5 digitos

      final url2 = Uri.parse("${this.url}/${randIdString}.json");

      final response = await http.get(url2);

      //print(response.body);
      if (response.body == "null") {
        return randIdString;
      }
    }
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

  //Obtener ip
  Future<String> getIpAddress() async {
    try {
      // Obtiene todas las interfaces de red disponibles
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, // Solo IPv4
        includeLoopback: false, // Excluye direcciones de loopback (127.0.0.1)
      );

      // Busca la primera interfaz con una dirección válida
      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (!address.isLoopback) {
            return address.address; // Devuelve la dirección IP
          }
        }
      }
    } catch (e) {
      print("Error al obtener la dirección IP: $e");
    }

    return "null"; // Devuelve null si no se encuentra una dirección IP
  }
}
