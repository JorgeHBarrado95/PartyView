class Authservice {
  static final Authservice _instance = Authservice._internal();

  Authservice._internal();

  factory Authservice() {
    return _instance;
  }

  String? _token;
  String? _displayName;

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
}
