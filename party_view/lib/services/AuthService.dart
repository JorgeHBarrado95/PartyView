import 'package:party_view/models/Sala.dart';

class Authservice {
  static final Authservice _instance = Authservice._internal();

  Authservice._internal();

  factory Authservice() {
    return _instance;
  }

  String? _token;
  String? _displayName;
  Sala? _sala;

  //Token
  Future<void> saveToken(String token) async {
    _token = token;
  }

  String? getToken() {
    return _token;
  }

  void clearToken() {
    _token = null;
  }

  //Nombre
  Future<void> saveDisplayName(String nombre) async {
    _displayName = nombre;
  }

  String? getDisplayName() {
    return _displayName;
  }

  void clearDisplayName() {
    _displayName = null;
  }

  //Sala
  Future<void> saveSala(Sala sala) async {
    _sala = sala;
  }

  Sala? getSala() {
    return _sala;
  }

  void clearSala() {
    _sala = null;
  }
}
