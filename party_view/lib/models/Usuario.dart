
class Usuario { //Es solo pa el login
  String email;
  String password;
  String? displayName;

  Usuario({required this.email, required this.password, this.displayName});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      email: json["email"],
      password: json["password"],
      displayName: json["displayName"],
    );
  }
}
