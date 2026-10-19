import 'package:flutter/material.dart';

class PersonalityProfile {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const PersonalityProfile({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}