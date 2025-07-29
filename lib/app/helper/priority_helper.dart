import 'package:flutter/material.dart';

class PriorityHelper {
  static String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }
  
  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  static Color getPriorityBackgroundColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.withValues(alpha: 0.1);
      case 2:
        return Colors.orange.withValues(alpha: 0.1);
      case 3:
        return Colors.green.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }
  
  static IconData getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icons.priority_high;
      case 2:
        return Icons.remove_circle_outline;
      case 3:
        return Icons.low_priority;
      default:
        return Icons.help_outline;
    }
  }
}