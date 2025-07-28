import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/app/const/meta-seo.dart';
import 'package:jokita/app/router/app_router.gr.dart';
import 'package:jokita/presentation/providers/auth_state_provider.dart';

@RoutePage()
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    MetaSeoHelper.setupDashboard(); // Ganti sesuai halaman
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              AutoRouter.of(
                context,
              ).replacePath('/signin'); // Kembali ke signin setelah logout
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to your Dashboard!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            if (authState != null)
              Column(
                children: [
                  Text('User ID: ${authState.id}'),
                  Text('Username: ${authState.username}'),
                  Text('Email: ${authState.email}'),
                  Text('Role: ${authState.role}'),
                ],
              )
            else
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pushRoute(const FileToolRoute());
              },
              child: const Text('FIle'),
            ),
            const SizedBox(height: 20),

             ElevatedButton(
              onPressed: () {
                context.pushRoute(const DiagramToolRoute());
              },
              child: const Text('Diagram'),
            ),
            const SizedBox(height: 20),

              ElevatedButton(
              onPressed: () {
                context.pushRoute(const ImageToolRoute());
              },
              child: const Text('Image'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
