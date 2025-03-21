import 'package:flutter/material.dart';
import 'package:party_view/models/Usuario.dart';
import 'package:party_view/services/LoginService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controladores para los campos de texto
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _confirmarContrasenaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double containerWidth = size.width * 0.4;

    return Scaffold(
      body: Center(
        child: Container(
          width: containerWidth,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text("Iniciar sesión", style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 15),

              TextField(
                decoration: InputDecoration(labelText: "Correo"),
                controller: _correoController,
              ),
              const SizedBox(height: 15),

              TextField(
                decoration: InputDecoration(labelText: "Nombre de usuario"),
                controller: _nombreController,
              ),
              const SizedBox(height: 15),

              TextField(
                decoration: InputDecoration(labelText: "Contraseña"),
                controller: _contrasenaController,
                obscureText: true,
              ),
              const SizedBox(height: 15),

              TextField(
                decoration: InputDecoration(labelText: "Confirmar Contraseña"),
                controller: _confirmarContrasenaController,
                obscureText: true,
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: login,
                    child: Text("Iniciar sesión"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(onPressed: () {}, child: Text("Registrarse")),

                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: registro,
                    child: Text("Registrarse2"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registro() async {
    String nombre = _nombreController.text.trim();
    String correo = _correoController.text.trim();
    String contrasena = _contrasenaController.text.trim();
    String confirmarContrasena = _confirmarContrasenaController.text.trim();

    if (validarRegistro(nombre, correo, contrasena, confirmarContrasena)) {
      Usuario usuario = Usuario(
        displayName: _nombreController.text,
        email: _correoController.text,
        password: _contrasenaController.text,
      );

      try {
        await Loginservice().registro(usuario);
      } catch (e) {
        print(e);
      }
    }
  }

  bool validarRegistro(nombre, correo, contrasena, confirmarContrasena) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (nombre.isEmpty ||
        correo.isEmpty ||
        contrasena.isEmpty ||
        confirmarContrasena.isEmpty) {
      print("Faltan datos");
      return false;
    }

    if (contrasena.length < 6) {
      print("La contraseña debe tener al menos 6 caracteres");
      return false;
    }

    if (contrasena != confirmarContrasena) {
      print("Las contraseñas no coinciden");
      return false;
    }

    if (!emailRegExp.hasMatch(correo)) {
      print("Correo inválido");
      return false;
    }

    return true;
  }

  void login() async {
    String correo = _correoController.text.trim();
    String contrasena = _contrasenaController.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      print("Faltan datos");
      return;
    }

    Usuario usuario = Usuario(
      email: _correoController.text,
      password: _contrasenaController.text,
    );

    try {
      await Loginservice().login(usuario);
    } catch (e) {
      print(e);
    }
  }
}
