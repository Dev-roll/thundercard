import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// サービスに関する変数
final Uri shortBaseUri = Uri.parse('https://thundercard.page.link/');
final Uri originalBaseUri = Uri.parse('https://thundercard.gajeroll.com/');
const String playStoreUrl =
    'https://play.google.com/store/apps/details?id=app.web.thundercard';
const String appStoreUrl =
    'https://apps.apple.com/us/app/thundercard/id6444392874';
const String shareThundercardUrl = 'https://thundercard-test.web.app/';

// カードに表示する所属、肩書き等
const List<String> dataTypes = [
  'company',
  'position',
  'address',
  'bio',
];

const Map<String, String> linkTypeToBaseUrl = {
  'address': 'https://www.google.com/maps/search/?api=1&query=', //これを先頭に
  'url': '',
  // 'company': 'https://business_rounded.com/',
  // 'at': 'https://alternate_email_rounded.com/',
  // 'location': 'https://location_on_rounded.com/',
  'twitter': 'https://twitter.com/',
  // 'youtube': 'https://youtube.com/',
  'instagram': 'https://instagram.com/',
  // 'facebook': 'https://facebook.com/',
  'tiktok': 'https://tiktok.com/@',
  'github': 'https://github.com/',
  'linkedin': 'https://www.linkedin.com/in/',
  'email': 'mailto:',
  'tel': 'tel:',
  // 'address': 'https://google.com/maps/search/',
  // 'address': 'https://google.com/maps/search/?q=',
  // 'address': 'comgooglemaps://?q=',
  // 'discord': 'https://discord.com/',
  // 'slack': 'https://slack.com/',
  // 'figma': 'https://figma.com/',
  // 'stackOverflow': 'https://stackOverflow.com/',
  // 'dribbble': 'https://dribbble.com/',
  // 'medium': 'https://medium.com/',
  // 'codepen': 'https://codepen.com/',
  // 'dropbox': 'https://dropbox.com/',
  // 'cloudflare': 'https://cloudflare.com/',
  // 'airbnb': 'https://airbnb.com/',
  // 'vimeo': 'https://vimeo.com/',
  // 'whatsapp': 'https://whatsapp.com/',
  // 'line': 'https://line.com/',
  // 'telegram': 'https://telegram.com/',
  // 'pinterest': 'https://pinterest.com/',
  // 'googleplay': 'https://googlePlay.com/',
  // 'gitlab': 'https://gitlab.com/',
  // 'twitch': 'https://twitch.com/',
  // 'xbox': 'https://xbox.com/',
  // 'unity': 'https://unity.com/',
  // 'trello': 'https://trello.com/',
  // 'tumblr': 'https://tumblr.com/',
  // 'swift': 'https://swift.com/',
  // 'reddit': 'https://reddit.com/',
  // 'sketch': 'https://sketch.com/',
  // 'mastodon': 'https://mastodon.com/',
  // 'spotify': 'https://spotify.com/',
};

const Map<String, IconType> linkTypeToIconType = {
  'company': IconType.company,
  'position': IconType.position,
  'address': IconType.address,
  'bio': IconType.bio,
  'tel': IconType.tel,
  'url': IconType.url,
  'email': IconType.email,
  'at': IconType.at,
  'location': IconType.location,
  'github': IconType.github,
  'twitter': IconType.twitter,
  'youtube': IconType.youtube,
  'instagram': IconType.instagram,
  'facebook': IconType.facebook,
  'tiktok': IconType.tiktok,
  'linkedin': IconType.linkedin,
  'discord': IconType.discord,
  'slack': IconType.slack,
  'figma': IconType.figma,
  'stackOverflow': IconType.stackOverflow,
  'dribbble': IconType.dribbble,
  'medium': IconType.medium,
  'codepen': IconType.codepen,
  'dropbox': IconType.dropbox,
  'cloudflare': IconType.cloudflare,
  'airbnb': IconType.airbnb,
  'vimeo': IconType.vimeo,
  'whatsapp': IconType.whatsapp,
  'line': IconType.line,
  'telegram': IconType.telegram,
  'pinterest': IconType.pinterest,
  'googleplay': IconType.googleplay,
  'gitlab': IconType.gitlab,
  'twitch': IconType.twitch,
  'xbox': IconType.xbox,
  'unity': IconType.unity,
  'trello': IconType.trello,
  'tumblr': IconType.tumblr,
  'swift': IconType.swift,
  'reddit': IconType.reddit,
  'sketch': IconType.sketch,
  'mastodon': IconType.mastodon,
  'spotify': IconType.spotify,
};

//カードに表示するアイコンの種類を幅広く登録
enum IconType {
  nl,
  company,
  position,
  address,
  bio,
  tel,
  url,
  email,
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

const Map<IconType, IconData> iconTypeToIconData = {
  // IconType.company: Icons.business_rounded,
  IconType.company: Icons.apartment_rounded,
  // IconType.position: Icons.alternate_email_rounded,
  IconType.position: Icons.business_rounded,
  // IconType.position: FontAwesomeIcons.userTie,
  IconType.address: Icons.location_on_rounded,
  IconType.tel: Icons.phone_rounded,
  IconType.bio: Icons.comment_rounded,
  IconType.url: Icons.link_rounded,
  IconType.email: Icons.mail_rounded,
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

List<String> linkTypes = linkTypeToBaseUrl.keys.toList().sublist(1);

Map<String, IconData> linkTypeToIconData = Map.fromIterables(
  linkTypes,
  linkTypes.map(
    (e) => iconTypeToIconData[linkTypeToIconType[e]] ?? Icons.link_rounded,
  ),
);

// 色
const Color white = Color(0xFFFAFAFA);
const Color seedColor = Color(0xFF00B1D8);

// カードの表示形式
enum CardType {
  preview,
  small,
  normal,
  large,
}

// テーマ
final List<ThemeMode> themeList = [
  ThemeMode.system,
  ThemeMode.dark,
  ThemeMode.light,
];

// メニュー
const menuItmCardDetails = <String>[
  '削除',
];
const menuIcnCardDetails = <Icon>[
  Icon(Icons.delete_outline_rounded),
];

const menuItmNotificationItemPage = <String>[
  '未読にする',
  '削除',
];
const menuIcnNotificationItemPage = <Icon>[
  Icon(Icons.mark_email_unread_rounded),
  Icon(Icons.delete_outline_rounded),
];
