import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CardType {
  normal,
  extended,
}

const white = Color(0xFFFAFAFA);
const seedColor = Color(0xFF00B1D8);

const linkTypes = [
  'url',
  'twitter',
  'instagram',
  'github',
];

const Map<String, IconData> linkTypeToIconData = {
  'url': Icons.link_rounded,
  'twitter': FontAwesomeIcons.twitter,
  'instagram': FontAwesomeIcons.instagram,
  'github': FontAwesomeIcons.github,
};
