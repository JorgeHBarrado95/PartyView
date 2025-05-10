import 'package:flutter/material.dart';
import 'package:party_view/widget/CustomSnackBar.dart';

class Registrovalidacion {
  void registro(BuildContext context, String nombre, String correo, String contrasena, String confirmarContrasena) {
    final RegExp _gmailValidacion = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty || confirmarContrasena.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.error(
            "¡Faltan campos por rellenar!",
            "",
          ),
        );
      return;
    }

    if (!_gmailValidacion.hasMatch(correo)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.error(
            "¡Pon un correo valido!",
            "",
          ),
        );
      return;
    }

    if (contrasena.length < 6) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.error(
            "La contraseña debe tener al menos 6 caracteres",
            "",
          ),
        );
      return;
    }

    if (contrasena != confirmarContrasena) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.error(
            "Las contraseñas no coinciden",
            "",
          ),
        );
      return;
    }
    

  }
}