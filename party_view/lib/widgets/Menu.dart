import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class Menu extends StatelessWidget {
  final void Function(String url) loadUrl;
  const Menu({super.key, required this.loadUrl});

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder:
          (context) => [
            PullDownMenuHeader(
              leading: ColoredBox(
                color: CupertinoColors.systemBlue.resolveFrom(context),
              ),
              title: 'Nombre del perfil de usuario',
              subtitle: 'Anfitrion o invitado',
              onTap: () {},
              icon: CupertinoIcons.profile_circled,
            ),
            const PullDownMenuDivider.large(),
            PullDownMenuActionsRow.medium(
              items: [
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://www.netflix.com");
                  },
                  title: 'Netflix',
                  iconWidget: Image.asset("assets/iconMenu/netflix.png"),
                ),
                PullDownMenuItem(
                  onTap: () {
                    loadUrl(
                      "https://www.max.com/es/es?gclsrc=aw.ds&gad_source=1&gclid=Cj0KCQiA8fW9BhC8ARIsACwHqYoYk6omJnnnZP3BZTagsfzIeocn_t6KgNCZ5NaHww7yoYYRdoBWy50aAiqREALw_wcB",
                    );
                  },
                  title: 'Max',
                  iconWidget: Image.asset("assets/iconMenu/max.png"),
                ),
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://www.primevideo.com/");
                  },
                  title: 'Amazon Prime Video',
                  iconWidget: Image.asset("assets/iconMenu/amazon.png"),
                ),
              ],
            ),
            const PullDownMenuDivider.large(),
            PullDownMenuActionsRow.medium(
              items: [
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://www.disneyplus.com/");
                  },
                  title: 'Disney +',
                  iconWidget: Image.asset("assets/iconMenu/disney.png"),
                ),
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://www.youtube.com/");
                  },
                  title: 'Youtube',
                  iconWidget: Image.asset("assets/iconMenu/youtube.png"),
                ),
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://www.twitch.tv/");
                  },
                  title: 'Twitch',
                  iconWidget: Image.asset("assets/iconMenu/twitch.png"),
                ),
              ],
            ),
            const PullDownMenuDivider.large(),
            PullDownMenuActionsRow.medium(
              items: [
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://kick.com/");
                  },
                  title: 'Kick',
                  iconWidget: Image.asset("assets/iconMenu/kick.png"),
                ),
                PullDownMenuItem(
                  onTap: () {
                    loadUrl("https://google.com/");
                  },
                  title: 'Google',
                  iconWidget: Image.asset("assets/iconMenu/google.png"),
                ),
              ],
            ),
          ],
      animationBuilder: null,
      position: PullDownMenuPosition.automatic,
      buttonBuilder:
          (context, onPressed) => IconButton(
            icon: const Icon(Icons.keyboard_double_arrow_left),
            onPressed: onPressed,
          ),
    );
  }
}
