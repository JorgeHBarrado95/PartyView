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
<<<<<<< HEAD
=======
  static Future<SnackBar> error(String title, String message) async {
    final player = AudioPlayer();
    await player.play(AssetSource("sounds/notificacionPOP.mp3"));
    
>>>>>>> 0f9a673 (Conexion Sala)
=======
    final _player = AudioPlayer();
    _player.play(AssetSource("sounds/notificacionERROR.mp3"));

>>>>>>> b87b0ba (Notificaciones)
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

    static SnackBar info(String title, String message) {
    final _player = AudioPlayer();
    _player.play(AssetSource("sounds/notificacionPOP.mp3"));

    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.warning,
      ),
    );
  }
}
