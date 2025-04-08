import 'dart:io';

class Persona {
  late String nombre;
  late String ip;

  Persona({required this.nombre, required this.ip});

  Map<String, dynamic> toJson() {
    return {"nombre": nombre, "ip": ip};
  }

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(nombre: json["nombre"], ip: json["ip"]);
  }
}
