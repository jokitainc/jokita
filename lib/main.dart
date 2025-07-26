import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/app_main.dart';

void main() {
  runApp(
    // ProviderScope diperlukan untuk menggunakan Riverpod
    const ProviderScope(
      child: JokitaApp(),
    ),
  );
}
