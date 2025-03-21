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
                    onPressed: () {
                      // Lógica de inicio de sesión
                      String correo = _correoController.text;
                      String contrasena = _contrasenaController.text;
                      print("Correo: $correo, Contraseña: $contrasena");
                    },
                    child: Text("Iniciar sesión"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(onPressed: () {}, child: Text("Registrarse")),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Usuario usuario = Usuario(
                        displayName: _nombreController.text,
                        email: _correoController.text,
                        password: _contrasenaController.text,
                      );

                      try {
                        await Loginservice().registro(usuario);
                        //print("Usuario registrado: ${usuario.toJson()}");
                      } catch (e) {
                        print(e);
                      }
                    },
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
}
