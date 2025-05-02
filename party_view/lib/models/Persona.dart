import 'dart:io';

class Persona {
  late String nombre;
  late String ip;

  Persona({required this.nombre, required this.ip});

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(ip: json["ip"], nombre: json["nombre"]);
  }

  Map<String, dynamic> toJson() {
    return {"ip": ip, "nombre": nombre};
  }

  String toString() {
    return "Persona(nombre: $nombre, ip: $ip)";
  }
}
