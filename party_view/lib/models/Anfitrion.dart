class Anfitrion {
  late String nombre;
  late String ip;

  Anfitrion({required this.nombre, required this.ip});

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'ip': ip};
  }

  factory Anfitrion.fromJson(Map<String, dynamic> json) {
    return Anfitrion(nombre: json['nombre'], ip: json['ip']);
  }
}
