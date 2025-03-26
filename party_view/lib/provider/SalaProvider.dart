import 'package:flutter/material.dart';
import 'package:party_view/models/Sala.dart';

class SalaProvider with ChangeNotifier {
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
}
