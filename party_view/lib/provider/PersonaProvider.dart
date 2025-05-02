import 'dart:io';

import 'package:flutter/material.dart';
import 'package:party_view/models/Persona.dart';

//COMO INICIALIZAR EL PROVIDER
//final personaProvider = Provider.of<PersonaProvider>(
//  context,
//  listen: false,
//);

/// Proveedor de ejemplo para manejar un contador.
class PersonaProvider with ChangeNotifier {
  Persona? _persona; // Define la variable 'persona'.
  String nombre = ""; // Define la variable 'nombre'.

  // Getter para 'persona'.
  Persona? get getPersona => _persona;

  // Getter para 'nombre'.
  String get getNombre => nombre;

  // Setter para 'nombre'.
  set setNombre(String nuevoNombre) {
    nombre = nuevoNombre;
    notifyListeners(); // Notifica a los oyentes sobre el cambio.
  }

  Future<void> crearPersona(String nombre) async {
    // Cambia a Future para manejar la asincronía.
    final ip = await _getIpAddress(); // Espera el resultado de _getIpAddress.
    _persona = Persona(nombre: nombre, ip: ip); // Crea y asigna la persona.
    print("persona creada");
  }

  /// Obtiene la dirección IP del dispositivo.
  ///
  /// Retorna un [String] con la dirección IP o "null" si no se encuentra.
  Future<String> _getIpAddress() async {
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
}
