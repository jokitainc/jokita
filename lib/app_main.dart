import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/app/router/app_router.dart';
import 'package:jokita/app/theme/app_theme.dart';

class JokitaApp extends ConsumerWidget {
  const JokitaApp({super.key});

  // Inisialisasi AppRouter
  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Jokita App',
      theme: appTheme, // Gunakan tema yang sudah kita definisikan
      routerConfig: _appRouter.config(), // Konfigurasi router dari AutoRoute
    );
  }
}