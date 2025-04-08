<<<<<<< HEAD
=======
import 'package:audioplayers/audioplayers.dart';
>>>>>>> 0f9a673 (Conexion Sala)
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar aprobacion(String title, String message) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.success,
      ),
    );
  }

<<<<<<< HEAD
  static SnackBar error(String title, String message) {
=======
  static Future<SnackBar> error(String title, String message) async {
    final player = AudioPlayer();
    await player.play(AssetSource("sounds/notificacionPOP.mp3"));
    
>>>>>>> 0f9a673 (Conexion Sala)
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    );
  }
}
