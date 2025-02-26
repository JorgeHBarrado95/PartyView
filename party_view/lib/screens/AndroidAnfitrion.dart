import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          Column(
            children: [Expanded(child: WebViewWidget(controller: controller))],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Menu(loadUrl: loadUrl),
          ),
        ],
      ),
    );
  }
}

// Botón de navegación
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
