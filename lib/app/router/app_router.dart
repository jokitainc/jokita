import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/app/router/app_router.gr.dart';
import 'package:jokita/presentation/providers/auth_state_provider.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: LandingRoute.page,
      path: '/',
      initial: true,
      meta: {
        'name': 'Jokita - Platform Joki Tugas & Profesional Assistant',
        'description':
            'Jokita adalah platform Flutter untuk membantu klien dan profesional menyelesaikan tugas secara efisien. Dengan antarmuka clean dan tools produktif, Jokita siap menjadi partner kerja digitalmu.',
      },
    ),
    AutoRoute(
      page: SignInRoute.page,
      path: '/signin',
      meta: {
        'name': 'Masuk - Jokita',
        'description':
            'Masuk ke akun Jokita dan mulai kelola tugasmu dengan bantuan profesional. Aman, cepat, dan terintegrasi.',
      },
    ),
    AutoRoute(
      page: SignUpRoute.page,
      path: '/signup',
      meta: {
        'name': 'Daftar - Jokita',
        'description':
            'Daftarkan dirimu di Jokita dan bergabung dalam platform joki tugas profesional. Mulai bantu dan dibantu sekarang.',
      },
    ),
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      meta: {
        'name': 'Dashboard - Jokita',
        'description':
            'Pusat kontrol utama pengguna Jokita untuk mengelola tugas, melihat progres, dan menggunakan tools produktif.',
      },
    ),
    AutoRoute(
      page: FileToolRoute.page,
      path: '/file-tool',
      meta: {
        'name': 'File Tool - Jokita',
        'description':
            'Tool unggulan Jokita untuk mengelola dan memproses file tugas dengan cepat dan akurat.',
      },
    ),
    AutoRoute(
      page: DiagramToolRoute.page,
      path: '/diagram-tool',
      meta: {
        'name': 'Diagram Tool - Jokita',
        'description':
            'Buat dan edit diagram dengan mudah menggunakan fitur Diagram Tool dari Jokita. Praktis untuk tugas visual.',
      },
    ),
    AutoRoute(
      page: ImageToolRoute.page,
      path: '/image-tool',
      meta: {
        'name': 'Image Tool - Jokita',
        'description':
            'Tool untuk memodifikasi dan mengoptimalkan gambar tugas. Cocok untuk presentasi dan dokumen visual.',
      },
    ),
    AutoRoute(
      page: ShowcaseRoute.page,
      path: '/showcase',
      meta: {
        'name': 'Showcase - Jokita',
        'description':
            'Lihat hasil karya, studi kasus, dan portfolio tugas dari para pengguna Jokita. Inspirasi dan bukti kualitas.',
      },
    ),
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
