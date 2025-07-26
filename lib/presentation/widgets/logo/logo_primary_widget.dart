import 'package:flutter/material.dart';
import 'package:jokita/app/theme/colors_theme.dart';

class LogoPrimaryWidget extends StatelessWidget {
  const LogoPrimaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
        children: [
          const Icon(Icons.flutter_dash, size: 30, color: AppColors.white),
          const SizedBox(width: 12),
          const Text('Jokita', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
        ],
      );
  }
}