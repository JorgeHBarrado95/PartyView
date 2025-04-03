import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:party_view/models/Anfitrion.dart';
import 'package:party_view/models/Sala.dart';
import 'package:party_view/services/AuthService.dart';
import 'package:party_view/services/GestorSalasService.dart';

class SalaProvider with ChangeNotifier {
  final GestorSalasService _gestorSalasService = GestorSalasService();
  Sala? _sala;

  Sala? get sala => _sala;

  void setSala(Sala sala) {
    _sala = sala;
    notifyListeners(); // Notifica a los widgets que el estado ha cambiado
  }

  void clearSala() {
    _sala = null;
    notifyListeners(); // Notifica que la sala ha sido eliminada
  }

  void incrementarCapacidad() {
    _sala!.capacidad++;
    notifyListeners();
  }

  void disminuirCapacidad() {
    if (_sala!.capacidad > 2) {
      _sala!.capacidad--;
      notifyListeners();
    }
  }

  void estado(String estado) {
    _sala!.estado = estado;
    notifyListeners();
    //print(_sala!.estado);
  }

  Future<void> crearSala() async {
    _sala = Sala(
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
    //print("notificado");
    notifyListeners();
  }

  //Genera un id rand pa la sala y comprueba q existe
  Future<String> idSalaComp() async {
    final random = Random();
    bool _idMal = true;
    String _randIdString = "";
    while (_idMal) {
      int _randId = random.nextInt(100000);
      //print(randId);

      _randIdString = _randId.toString().padLeft(
        5,
        "0",
      ); //Se añaden 0 para q simpre sean 5 digitos

      if (await _gestorSalasService.comprobarSiExiste(_randIdString) !=
          "null") {
        //print("id sala: $randIdString");
        _idMal = false; //Si no existe, se sale del bucle
      }
    }
    return _randIdString;
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
