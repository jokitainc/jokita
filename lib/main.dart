import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/app_main.dart';
import 'package:meta_seo/meta_seo.dart';

void main() {
   if (kIsWeb) {
    MetaSEO().config();
  }
  runApp(
    // ProviderScope diperlukan untuk menggunakan Riverpod
    const ProviderScope(
      child: JokitaApp(),
    ),
  );
}
