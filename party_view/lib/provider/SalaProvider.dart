import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:party_view/models/Persona.dart';
import 'package:party_view/models/Sala.dart';
import 'package:party_view/services/AuthService.dart';
import 'package:party_view/services/GestorSalasService.dart';

/// Proveedor que gestiona el estado de una sala y su sincronización con la base de datos.
class SalaProvider with ChangeNotifier {
  final GestorSalasService _gestorSalasService = GestorSalasService();
  Sala? _sala; // Sala actual gestionada por el proveedor.
  Timer? _timer; // Temporizador para actualizar invitados periódicamente.

  /// Obtiene la sala actual.
  Sala? get sala => _sala;

  /// Establece una nueva sala y notifica a los widgets que el estado ha cambiado.
  ///
  /// [sala] La nueva sala a establecer.
  void setSala(Sala sala) {
    _sala = sala;
    notifyListeners();
  }

  /// Limpia la sala actual y notifica a los widgets.
  void clearSala() {
    _sala = null;
    notifyListeners();
  }

  /// Incrementa la capacidad de la sala en 1 y sincroniza con la base de datos.
  void incrementarCapacidad() {
    _sala!.capacidad++;
    notifyListeners();
    _sincronizarBD();
  }

  /// Disminuye la capacidad de la sala en 1 si es mayor a 2 y sincroniza con la base de datos.
  void disminuirCapacidad() {
    if (_sala!.capacidad > 2) {
      _sala!.capacidad--;
      notifyListeners();
      _sincronizarBD();
    }
  }

  /// Cambia el estado de la sala y sincroniza con la base de datos.
  ///
  /// [estado] El nuevo estado de la sala.
  void estado(String estado) {
    _sala!.estado = estado;
    notifyListeners();
    _sincronizarBD();
  }

  /// Crea una nueva sala con un ID aleatorio y configura sus valores iniciales.
  Future<void> crearSala() async {
    _sala = Sala(
      id: await idSalaComp(), // Genera un ID único para la sala.
      capacidad: 5,
      video: true,
      estado: "Abierto",
      anfitrion: Persona(
        nombre:
            Authservice().getDisplayName() ??
            "Desconocido", // Obtiene el nombre del anfitrión.
        ip: await getIpAddress(), // Obtiene la dirección IP del anfitrión.
      ),
      invitados: [],
    );
    notifyListeners();
  }

  /// Genera un ID aleatorio para la sala y verifica que no exista en la base de datos.
  ///
  /// Retorna un [String] con el ID generado.
  Future<String> idSalaComp() async {
    final random = Random();
    bool _idMal = true;
    String _randIdString = "";
    while (_idMal) {
      int _randId = random.nextInt(100000);
      _randIdString = _randId.toString().padLeft(
        5,
        "0",
      ); // Asegura que el ID tenga 5 dígitos.

      if (await _gestorSalasService.comprobarSiExiste(_randIdString) !=
          "null") {
        _idMal = false; // Si el ID no existe, sale del bucle.
      }
    }
    return _randIdString;
  }

  /// Obtiene la dirección IP del dispositivo.
  ///
  /// Retorna un [String] con la dirección IP o "null" si no se encuentra.
  Future<String> getIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, // Solo direcciones IPv4.
        includeLoopback: false, // Excluye direcciones de loopback.
      );

      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (!address.isLoopback) {
            return address.address; // Devuelve la primera dirección IP válida.
          }
        }
      }
    } catch (e) {
      print("Error al obtener la dirección IP: $e");
    }

    return "null"; // Devuelve "null" si no se encuentra una dirección IP.
  }

  /// Sincroniza la sala actual con la base de datos.
  Future<void> _sincronizarBD() async {
    await _gestorSalasService.addSala(
      _sala!,
    ); //Uso el metodo con el q creo la sala, porq hace lo mismo
  }

  /// Obtiene la lista de invitados de la sala desde la base de datos.
  Future<void> _obtenerInvitados() async {
    _sala!.invitados = await _gestorSalasService.obtenerInvitados(_sala!.id);
    notifyListeners();
  }

  /// Inicia un temporizador que actualiza la lista de invitados cada 1 segundo.
  void iniciarTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (sala != null) {
        await _obtenerInvitados();
      }
    });
  }

  /// Detiene el temporizador.
  void detenerTimer() {
    _timer?.cancel();
  }
}
