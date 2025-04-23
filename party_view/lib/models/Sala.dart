import "package:party_view/models/Persona.dart";

class Sala {
  late String id;
  late String estado;
  late num capacidad;
  late bool video;
  late Persona anfitrion;
  late List<Persona> invitados;
  late List<Persona> bloqueados;

  Sala({
    required this.id,
    required this.capacidad,
    required this.video,
    required this.estado,
    required this.anfitrion,
    required this.invitados,
    required this.bloqueados,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "capacidad": capacidad,
      "video": video,
      "estado": estado,
      "anfitrion": anfitrion.toJson(),
      "invitados": invitados.map((invitado) => invitado.toJson()).toList(),
      "bloqueados": bloqueados.map((invitado) => invitado.toJson()).toList(),
    };
  }

  factory Sala.fromJson(String id, Map<String, dynamic> json) {
    return Sala(
      id: id,
      capacidad: json["capacidad"],
      video: json["video"] is bool ? json["video"] : json["video"] == "true",
      estado: json["estado"],
      anfitrion: Persona.fromJson(json["anfitrion"]),
      invitados:
          (json["invitados"] as List? ?? [])
              .map((invitado) => Persona.fromJson(invitado))
              .toList(),
      bloqueados:
          (json["bloqueados"] as List? ?? [])
              .map((invitado) => Persona.fromJson(invitado))
              .toList(),
    );
  }
}
