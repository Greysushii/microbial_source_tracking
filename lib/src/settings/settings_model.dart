import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/settings/account_data.dart';
import 'package:microbial_source_tracking/src/settings/faq_page.dart';

class Setting {
  final String title;
  final Widget route;
  final IconData icon;

  Setting({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<Setting> settings = [
  Setting(
    title: 'Account Data',
    route: const AccountData(),
    icon: Icons.person_4,
  ),
  /* Setting(
    title: 'FAQ',
    route: const FAQpage(),
    icon: Icons.question_mark,
  ),
   Setting(
    title: 'Contact Us',
    route: AccountData(),
    icon: Icons.phone,
  ),
   Setting(
    title: 'Help Us',
    route: AccountData(),
    icon: Icons.handshake,
  ), */
  // Setting(
  //   title: 'Log Out',
  //   route: '/',
  //   icon: Icons.exit_to_app,
  // ),
  // Setting(
  //   title: 'Log Out',
  //   route: '/',
  //   icon: Icons.exit_to_app,
  // ),
];

// final List<Setting> settings2 = [
//   Setting(
//     title: 'FAQ',
//     route: '/',
//     title: 'FAQ',
//     route: '/',
//     icon: Icons.question_mark,
//   ),
//   Setting(
//     title: 'Contact Us',
//     route: '/',
//     title: 'Contact Us',
//     route: '/',
//     icon: Icons.phone,
//   ),
//   Setting(
//     title: 'Help Us',
//     route: '/',
//     title: 'Help Us',
//     route: '/',
//     icon: Icons.handshake,
//   ),
//   Setting(
//     title: 'Log Out',
//     route: '/',
//     title: 'Log Out',
//     route: '/',
//     icon: Icons.exit_to_app,
//   ),
// ];
