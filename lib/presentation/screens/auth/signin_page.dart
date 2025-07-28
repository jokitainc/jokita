import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jokita/app/const/meta-seo.dart';
import 'package:jokita/presentation/providers/auth_state_provider.dart';
final storage = FlutterSecureStorage();
@RoutePage()
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? token;

  @override
  void initState() {
    super.initState();
    MetaSeoHelper.setupSignIn();
    _loadToken();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    final authNotifier = ref.read(authStateProvider.notifier);
    try {
      await authNotifier.login(
        _emailController.text,
        _passwordController.text,
      );
      AutoRouter.of(context).replacePath('/dashboard');
    } catch (e) {
      print('Failed to login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Failed: ${e.toString()}')),
      );
    }
  }

Future<void> _loadToken() async {
    final result = await storage.read(key: 'token');
    setState(() {
      token = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$token'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: const Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  AutoRouter.of(context).pushPath('/signup'); // Navigasi ke halaman Sign Up
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
