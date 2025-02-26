import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:party_view/widgets/Menu.dart'; // Asegúrate de que esta ruta sea correcta

class Android extends StatefulWidget {
  const Android({super.key});

  @override
  _AndroidState createState() => _AndroidState();
}

class _AndroidState extends State<Android> {
  late final WebViewController controller;

  late Offset position = Offset(0, 400);

  void loadUrl(String url) {
    controller.loadRequest(Uri.parse(url));
  }

  @override
  void initState() {
    super.initState();

    // Controlador de la vista del navegador
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://www.google.com'));
  }

  // Constructor vista
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /**
      appBar: AppBar(
        title: const Text("Anfitrión"),
        actions: <Widget>[ControlNavegacion(webViewController: controller)],
      ),
      */
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double screenWidth = constraints.maxWidth;

          if (position.dx > screenWidth - 50)
            position = Offset(screenWidth - 50, position.dy);
          if (position.dy > screenHeight - 50)
            position = Offset(position.dx, screenHeight - 50);

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(child: WebViewWidget(controller: controller)),
                ],
              ),
              Positioned(
                left: position.dx,
                top: position.dy,
                child: Draggable(
                  feedback: Material(
                    child: Menu(loadUrl: loadUrl),
                    color: Colors.transparent,
                  ),
                  childWhenDragging:
                      Container(), // Widget vacío mientras se arrastra
                  onDragEnd: (details) {
                    setState(() {
                      // Asegurarse de que el botón no se salga de los límites de la pantalla
                      double newX = details.offset.dx;
                      double newY = details.offset.dy;

                      if (newX < 0) newX = 0;
                      if (newY < 0) newY = 0;
                      if (newX > screenWidth - 50)
                        newX =
                            screenWidth -
                            50; // Ajusta el valor 50 según el tamaño del botón

                      if (newY > screenHeight - 50)
                        newY =
                            screenHeight -
                            50; // Ajusta el valor 50 según el tamaño del botón

                      position = Offset(newX, newY);
                    });
                  },
                  child: Menu(loadUrl: loadUrl),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Botón de navegación NO SE USA
class ControlNavegacion extends StatelessWidget {
  ControlNavegacion({super.key, required this.webViewController});

  final WebViewController webViewController;
  final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }

  void loadUrl(String url) {
    webViewController.loadRequest(Uri.parse(url));
  }

  void limpiarCookies() {
    webViewController.clearCache();
    webViewController.clearLocalStorage();
    cookieManager.clearCookies();
  }
}
