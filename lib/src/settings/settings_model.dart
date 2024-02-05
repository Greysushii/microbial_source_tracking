import 'package:flutter/material.dart';

class Setting {
  final String  title;
  final String  route;
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
    route: '/', 
    icon: Icons.person_4,
  ),
  Setting(
    title: 'Change Name', 
    route: '/', 
    icon: Icons.book,
  ),
  Setting(
    title: 'Change Email', 
    route: '/', 
    icon: Icons.email,
  ),
  Setting(
    title: 'Change Password', 
    route: '/', 
    icon: Icons.key,
  ),
];

final List<Setting> settings2 = [
  Setting(
    title: 'FAQ', 
    route: '/', 
    icon: Icons.question_mark,
  ),
  Setting(
    title: 'Contact Us', 
    route: '/', 
    icon: Icons.phone,
  ),
  Setting(
    title: 'Help Us', 
    route: '/', 
    icon: Icons.handshake,
  ),
];

final List<Setting> settings3 = [
  Setting(
    title: 'FAQ', 
    route: '/', 
    icon: Icons.question_mark,
  ),
  Setting(
    title: 'Contact Us', 
    route: '/', 
    icon: Icons.phone,
  ),
  Setting(
    title: 'Help Us', 
    route: '/', 
    icon: Icons.handshake,
  ),
];