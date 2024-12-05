
import 'package:flutter/material.dart';

class CompanionTrait {
  final String name;
  final double value;
  final int color;
  final IconData icon;

  CompanionTrait({
    required this.name,
    required this.value,
    required this.color,
    required this.icon,
  });
}

class CompanionData {
  final String name;
  final String type;
  final String status;
  final IconData imageIcon;
  final List<CompanionTrait> traits;

  CompanionData({
    required this.name,
    required this.type,
    required this.status,
    required this.imageIcon,
    required this.traits,
  });
}