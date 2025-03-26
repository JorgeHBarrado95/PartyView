class Invitado {
  late String nombre;
  late String ip;

  Invitado({required this.nombre, required this.ip});

  Map<String, dynamic> toJson() {
    return {"nombre": nombre, "ip": ip};
  }

  factory Invitado.fromJson(Map<String, dynamic> json) {
    return Invitado(nombre: json["nombre"], ip: json["ip"]);
  }
}
