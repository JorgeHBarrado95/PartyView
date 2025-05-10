import 'package:flutter/material.dart';
import 'package:party_view/utils/registroValidacion.dart';

class RegistroScreen extends StatelessWidget {
  final TextEditingController campoNombre = TextEditingController();
  final TextEditingController campoEmail = TextEditingController();
  final TextEditingController campoContrasena = TextEditingController();
  final TextEditingController campoConfirmarContrasena = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Registrovalidacion _registroValidacion = Registrovalidacion();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Crear Cuenta",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: campoNombre,
                  decoration: InputDecoration(
                    labelText: "Nombre de usuario",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: campoEmail,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: campoContrasena,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: campoConfirmarContrasena,
                  decoration: InputDecoration(
                    labelText: "Confirmar contraseña",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    String nombre = campoNombre.text;
                    String email = campoEmail.text;
                    String contrasena = campoContrasena.text;
                    String confirmarContrasena = campoConfirmarContrasena.text;
                    _registroValidacion.registro(context, nombre, email, contrasena, confirmarContrasena);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Registrarse",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Text(
                    "¿Ya tienes cuenta? Inicia sesión",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}