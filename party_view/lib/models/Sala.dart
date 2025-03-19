import 'package:party_view/models/Anfitrion.dart';
import 'package:party_view/models/Invitado.dart';

class Sala {
  late String estado;
  late num capacidad;
  late bool video;
  late Anfitrion anfitrion;
  late List<Invitado> invitados;

  Sala({
    required this.capacidad,
    required this.video,
    required this.estado,
    required this.anfitrion,
    required this.invitados,
  });

  Map<String, dynamic> toJson() {
    return {
      'capacidad': capacidad,
      'video': video,
      'estado': estado,
      'anfitrion': anfitrion.toJson(),
      'invitados': invitados.map((invitado) => invitado.toJson()).toList(),
    };
  }

  factory Sala.fromJson(String id, Map<String, dynamic> json) {
    return Sala(
      capacidad: json['capacidad'],
      video: json['video'] is bool ? json['video'] : json['video'] == 'true',
      estado: json['estado'],
      anfitrion: Anfitrion.fromJson(json['anfitrion']),
      invitados:
          (json['invitados'] as List)
              .map((invitado) => Invitado.fromJson(invitado))
              .toList(),
    );
  }
}
