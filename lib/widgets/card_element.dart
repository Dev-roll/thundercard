import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IconType {
  nl,
  url,
  email,
  company,
  at,
  location,
  github,
  twitter,
  youtube,
  instagram,
  facebook,
  tiktok,
  linkedin,
  discord,
  slack,
  figma,
  stackOverflow,
  dribbble,
  medium,
  codepen,
  dropbox,
  cloudflare,
  airbnb,
  vimeo,
  whatsapp,
  line,
  telegram,
  pinterest,
  googleplay,
  gitlab,
  twitch,
  xbox,
  unity,
  trello,
  tumblr,
  swift,
  reddit,
  sketch,
  mastodon,
  spotify,
}

class CardElement extends StatelessWidget {
  CardElement({
    Key? key,
    required this.txt,
    this.type = IconType.nl,
    this.line = 1,
    this.size = 1,
    this.height = 1,
    this.opacity = 1,
  }) : super(key: key);
  String? txt;
  IconType type;
  int line;
  double size;
  double height;
  double opacity;

  Map<IconType, IconData> types = {
    IconType.url: Icons.link_rounded,
    IconType.email: Icons.mail_rounded,
    IconType.company: Icons.business_rounded,
    IconType.at: Icons.alternate_email_rounded,
    IconType.location: Icons.location_on_rounded,
    IconType.github: FontAwesomeIcons.github,
    IconType.twitter: FontAwesomeIcons.twitter,
    IconType.youtube: FontAwesomeIcons.youtube,
    IconType.instagram: FontAwesomeIcons.instagram,
    IconType.facebook: FontAwesomeIcons.facebook,
    IconType.tiktok: FontAwesomeIcons.tiktok,
    IconType.linkedin: FontAwesomeIcons.linkedin,
    IconType.discord: FontAwesomeIcons.discord,
    IconType.slack: FontAwesomeIcons.slack,
    IconType.figma: FontAwesomeIcons.figma,
    IconType.stackOverflow: FontAwesomeIcons.stackOverflow,
    IconType.dribbble: FontAwesomeIcons.dribbble,
    IconType.medium: FontAwesomeIcons.medium,
    IconType.codepen: FontAwesomeIcons.codepen,
    IconType.dropbox: FontAwesomeIcons.dropbox,
    IconType.cloudflare: FontAwesomeIcons.cloudflare,
    IconType.airbnb: FontAwesomeIcons.airbnb,
    IconType.vimeo: FontAwesomeIcons.vimeo,
    IconType.whatsapp: FontAwesomeIcons.whatsapp,
    IconType.line: FontAwesomeIcons.line,
    IconType.telegram: FontAwesomeIcons.telegram,
    IconType.pinterest: FontAwesomeIcons.pinterest,
    IconType.googleplay: FontAwesomeIcons.googlePlay,
    IconType.gitlab: FontAwesomeIcons.gitlab,
    IconType.twitch: FontAwesomeIcons.twitch,
    IconType.xbox: FontAwesomeIcons.xbox,
    IconType.unity: FontAwesomeIcons.unity,
    IconType.trello: FontAwesomeIcons.trello,
    IconType.tumblr: FontAwesomeIcons.tumblr,
    IconType.swift: FontAwesomeIcons.swift,
    IconType.reddit: FontAwesomeIcons.reddit,
    IconType.sketch: FontAwesomeIcons.sketch,
    IconType.mastodon: FontAwesomeIcons.mastodon,
    IconType.spotify: FontAwesomeIcons.spotify,
  };

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        type != IconType.nl
            ? Row(
                children: [
                  Icon(
                    types[type],
                    size: 4 * vw,
                    color: type != IconType.company
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: 1.5 * vw,
                  )
                ],
              )
            : const Text(''),
        Flexible(
          child: Container(
            child: Text(
              '$txt',
              style: TextStyle(
                fontSize: 2 * vw * size,
                color: type == IconType.nl &&
                        line == 1 //アイコンなし1行: onSecondaryContainer
                    ? Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(opacity)
                    : type == IconType.nl //アイコンなし複数行: onSecondaryContainer(0.8)
                        ? Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.8 * opacity)
                        : type !=
                                IconType
                                    .company //アイコンcompany以外（リンク）: onTertiaryContainer
                            ? Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer
                                // .tertiary
                                .withOpacity(opacity)
                            : Theme.of(context) //company: onSecondaryContainer
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(opacity),
                height: height,
              ),
              maxLines: line,
              overflow: line == 1 ? TextOverflow.fade : TextOverflow.ellipsis,
              softWrap: line == 1 ? false : true,
            ),
          ),
        ),
      ],
    );
  }
}
