import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/app/router/app_router.gr.dart';
import 'package:jokita/presentation/providers/auth_state_provider.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LandingRoute.page, path: '/', initial: true),
        AutoRoute(page: SignInRoute.page, path: '/signin'),
        AutoRoute(page: SignUpRoute.page, path: '/signup'),
        AutoRoute(page: DashboardRoute.page, path: '/dashboard'),
        AutoRoute(page: FileToolRoute.page, path: '/file-tool'),
        AutoRoute(page: DiagramToolRoute.page, path: '/diagram-tool'),
        AutoRoute(page: ImageToolRoute.page, path: '/image-tool'),
        AutoRoute(page: ShowcaseRoute.page, path: '/showcase'),
      ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final container = ProviderContainer();
    final authState = container.read(authStateProvider);

    if (authState != null) {
      // User sudah login, izinkan navigasi
      resolver.next(true);
    } else {
      // User belum login, arahkan ke halaman signin
      router.push(SignInRoute());
    }
  }
}