import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:party_view/widget/SeleccionarPantalla.dart';

class ReproduccionAnfitrion extends StatefulWidget {
  @override
  _ReproduccionAnfitrion createState() => _ReproduccionAnfitrion();
}

class _ReproduccionAnfitrion extends State<ReproduccionAnfitrion> {
  MediaStream? _localStream; ///[_localStream] es el flujo de datos captados al compartir la pantalla
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer(); ///[_localRenderer] es el renderizador de video que se utiliza para mostrar el flujo de datos en la pantalla
  bool _enLlamada = false; ///[_enLlamada] es un booleano que indica si se está en una llamada o no
  DesktopCapturerSource? fuenteSeleccionada;  ///[fuenteSeleccionada] es la fuente de la pantalla seleccionada

  @override
  void initState() {
    super.initState();
    iniciarRender();
  }

  @override
  void deactivate() { ///[deactivate] es un método que se llama cuando el widget se elimina del árbol de widgets
    super.deactivate();
    if (_enLlamada) {
      _stop();
    }
    _localRenderer.dispose();
  }

  Future<void> iniciarRender() async {
    await _localRenderer.initialize();
  }

  /// [seleccionarFuentePantalla] Esta funcion se encarga de seleccionar la fuente de la pantalla
  Future<void> seleccionarFuentePantalla(BuildContext context) async {
    if (WebRTC.platformIsDesktop) {
      // Linux y Windows
      final source = await showDialog<DesktopCapturerSource>(
        context: context,
        builder: (context) => SeleccionarPantalla(),
      );
      if (source != null) {
        await _hacerLlamada(source);
      }
    } else {
      if (WebRTC.platformIsAndroid) {
        // Android
        try {
          await solicitarPermisosSegundoPlano();
          await Future.delayed(Duration(milliseconds: 1000)); // Asegurar que el servicio esté activo
          await _hacerLlamada(null);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error al iniciar la proyección: $e',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      }
    }
  }

  Future<void> solicitarPermisosSegundoPlano([bool isRetry = false]) async {
    try {
      var hasPermissions = await FlutterBackground.hasPermissions;
      if (!isRetry) {
        const androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: 'Compartiendo pantalla',
          notificationText: 'Party View está compartiendo la pantalla.',
          notificationImportance: AndroidNotificationImportance.high,
          notificationIcon: AndroidResource(name: 'background_icon', defType: 'mipmap'),
        );
        hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
      }
      if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
        await FlutterBackground.enableBackgroundExecution();
      }
    } catch (e) {
      if (!isRetry) {
        return await Future<void>.delayed(const Duration(seconds: 1), () => solicitarPermisosSegundoPlano(true));
      }
      print('No se pudo iniciar la proyección de pantalla: $e');
    }
  }

  ///[_hacerLlamada] Esta función se encarga de hacer la llamada
  Future<void> _hacerLlamada(DesktopCapturerSource? source) async {
    setState(() {
      fuenteSeleccionada = source;
    });

    try {
      // Espera solo en Android para evitar crash por race condition con permisos o FlutterBackground
      if (WebRTC.platformIsAndroid) {
        await Future.delayed(Duration(milliseconds: 300));
      }

      var stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
        'video': fuenteSeleccionada == null
            ? true
            : {
                'deviceId': {'exact': fuenteSeleccionada!.id},
                'mandatory': {'frameRate': 30.0}
              }
      });

      stream.getVideoTracks()[0].onEnded = () {
        print('Captura de pantalla finalizada por el usuario.');
      };

      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print('Error al iniciar captura de pantalla: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al compartir pantalla. Verifica los permisos o intenta de nuevo.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 4),
          ),
        );
      }

      return;
    }

    if (!mounted) return;

    setState(() {
      _enLlamada = true;
    });
  }

  ///[_stop] Detiene la cap de pantalla
  Future<void> _stop() async {
    try {
      if (kIsWeb) {
        _localStream?.getTracks().forEach((track) => track.stop());
      }
      await _localStream?.dispose();
      _localStream = null;
      _localRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
  }
  ///[_colgar] es la función que se encarga de colgar la llamada
  Future<void> _colgar() async {

    await _stop();
    setState(() {
      _enLlamada = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
              child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white10,
            child: Stack(children: <Widget>[
              if (_enLlamada)
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(_localRenderer),
                )
            ]),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Si el boolean _inCalling es true, se ejecuta la función _hangUp(), si no, se ejecuta la función selectScreenSourceDialog(context)
          _enLlamada ? _colgar() : seleccionarFuentePantalla(context);
        },
        tooltip: _enLlamada ? 'Hangup' : 'Call',
        child: Icon(_enLlamada ? Icons.call_end : Icons.phone),
      ),
    );
  }
}