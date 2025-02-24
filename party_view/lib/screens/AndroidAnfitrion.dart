import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Android extends StatefulWidget {
  const Android({super.key});

  @override
  _AndroidState createState() => _AndroidState();
}

class _AndroidState extends State<Android> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    //Controlador de la vista de el navegador
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://www.google.com'));
  }

  //Contructor vista
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anfitrión"),
        actions: <Widget>[
          ControlNavegacion(webViewController: controller),
          MenuOpciones(webViewController: controller),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

//Botón de navegación
class ControlNavegacion extends StatelessWidget {
  const ControlNavegacion({super.key, required this.webViewController});

  final WebViewController webViewController;

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
}

enum OpcionMenu {
  netflix,
  max,
  amazon,
  disney,
  youtube,
  twitch,
  kick,
  google,
  limpiarCookiesCache,
}

class MenuOpciones extends StatefulWidget {
  const MenuOpciones({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  _MenuOpcionesState createState() => _MenuOpcionesState();
}

class _MenuOpcionesState extends State<MenuOpciones> {
  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OpcionMenu>(
      key: const ValueKey<String>("Opciones Men"),
      onSelected: (OpcionMenu value) {
        switch (value) {
          case OpcionMenu.netflix:
            _loadUrl("https://www.netflix.com");
            break;
          case OpcionMenu.max:
            _loadUrl("https://www.hbomax.com");
            break;
          case OpcionMenu.amazon:
            _loadUrl(
              "https://www.primevideo.com/-/es/offers/nonprimehomepage/ref=dv_web_force_root?language=es",
            );
            break;
          case OpcionMenu.disney:
            _loadUrl("https://www.disneyplus.com");
            break;
          case OpcionMenu.youtube:
            _loadUrl("https://www.youtube.com");
            break;
          case OpcionMenu.twitch:
            _loadUrl("https://www.twitch.tv");
            break;
          case OpcionMenu.kick:
            _loadUrl("https://www.kick.com");
            break;
          case OpcionMenu.google:
            _loadUrl("https://www.google.com");
            break;
          case OpcionMenu.limpiarCookiesCache:
            _limpiarCookies();
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<OpcionMenu>>[
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.netflix,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/netflix.png",
                    width: 30,
                    height: 30,
                  ),
                  Text("Netflix"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.max,
              child: Row(
                children: [
                  Image.asset("assets/iconMenu/max.png", width: 30, height: 30),
                  Text(" Max"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.amazon,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/amazon.png",
                    width: 30,
                    height: 30,
                  ),
                  Text(" Prime Video"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.disney,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/disney.png",
                    width: 30,
                    height: 30,
                  ),
                  Text(" Disney+"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.youtube,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/youtube.png",
                    width: 30,
                    height: 30,
                  ),
                  Text(" YouTube"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.twitch,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/twitch.png",
                    width: 30,
                    height: 30,
                  ),
                  Text(" Twitch"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.kick,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/kick.png",
                    width: 30,
                    height: 30,
                  ),
                  Text(" Kick"),
                ],
              ),
            ),
            PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.google,
              child: Row(
                children: [
                  Image.asset(
                    "assets/iconMenu/google.png",
                    width: 30,
                    height: 30,
                  ),
                  Text(" Google"),
                ],
              ),
            ),
            const PopupMenuItem<OpcionMenu>(
              value: OpcionMenu.limpiarCookiesCache,
              child: Row(
                children: [Icon(Icons.cookie), Text(" Limpiar Cookies")],
              ),
            ),
          ],
    );
  }

  void _loadUrl(String url) {
    widget.webViewController.loadRequest(Uri.parse(url));
  }

  void _limpiarCookies() {
    widget.webViewController.clearCache();
    widget.webViewController.clearLocalStorage();
    cookieManager.clearCookies();
  }
}
