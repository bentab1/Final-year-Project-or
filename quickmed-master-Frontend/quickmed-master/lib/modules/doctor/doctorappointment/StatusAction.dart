import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class StatusAction {
  final IconData icon;
  final String label;
  final Color color;
  final String nextStatus;
  final String actionKey;

  const StatusAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.nextStatus,
    required this.actionKey,
  });
}
