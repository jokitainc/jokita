import 'package:meta_seo/meta_seo.dart';

class MetaSeoHelper {
  static final _meta = MetaSEO();

  static void _baseConfig({
    required String title,
    required String description,
    required String ogImage,
    required String twitterImage,
    required String keywords,
  }) {
    _meta.config();

    _meta.nameContent(name: title, content: title);
    _meta.description(description: description);
    _meta.ogTitle(ogTitle: title);
    _meta.ogDescription(ogDescription: description);
    _meta.ogImage(ogImage: ogImage);
    _meta.twitterCard(twitterCard: TwitterCard.summaryLargeImage);
    _meta.twitterTitle(twitterTitle: title);
    _meta.twitterDescription(twitterDescription: description);
    _meta.twitterImage(twitterImage: twitterImage);
    _meta.keywords(keywords: keywords);
    _meta.author(author: 'Jokita Team');
    _meta.robots(robotsName: RobotsName.robots, content: 'index, follow');
    _meta.viewport(viewport: 'width=device-width, initial-scale=1.0');
    _meta.charset(charset: 'UTF-8');
  }

  static void setupLanding() => _baseConfig(
        title: 'Jokita - Platform Joki Tugas & Profesional Assistant',
        description:
            'Jokita adalah platform Flutter untuk membantu klien dan profesional menyelesaikan tugas secara efisien. Dengan antarmuka clean dan tools produktif, Jokita siap menjadi partner kerja digitalmu.',
        ogImage: 'https://yourdomain.com/assets/og-image.jpg',
        twitterImage: 'https://yourdomain.com/assets/twitter-image.jpg',
        keywords: 'Joki tugas, asisten profesional, platform Flutter, tugas mahasiswa, bantuan tugas, Jokita',
      );

  static void setupSignIn() => _baseConfig(
        title: 'Masuk - Jokita',
        description: 'Masuk ke akun Jokita dan mulai kelola tugasmu dengan bantuan profesional. Aman, cepat, dan terintegrasi.',
        ogImage: 'https://yourdomain.com/assets/signin.jpg',
        twitterImage: 'https://yourdomain.com/assets/signin-twitter.jpg',
        keywords: 'Login Jokita, masuk Jokita, akun Jokita, joki tugas login',
      );

  static void setupSignUp() => _baseConfig(
        title: 'Daftar - Jokita',
        description: 'Daftarkan dirimu di Jokita dan bergabung dalam platform joki tugas profesional. Mulai bantu dan dibantu sekarang.',
        ogImage: 'https://yourdomain.com/assets/signup.jpg',
        twitterImage: 'https://yourdomain.com/assets/signup-twitter.jpg',
        keywords: 'Daftar Jokita, buat akun Jokita, registrasi joki tugas, asisten tugas',
      );

  static void setupDashboard() => _baseConfig(
        title: 'Dashboard - Jokita',
        description: 'Pusat kontrol utama pengguna Jokita untuk mengelola tugas, melihat progres, dan menggunakan tools produktif.',
        ogImage: 'https://yourdomain.com/assets/dashboard.jpg',
        twitterImage: 'https://yourdomain.com/assets/dashboard-twitter.jpg',
        keywords: 'Dashboard Jokita, kontrol tugas, task management, asisten kerja digital',
      );

  static void setupFileTool() => _baseConfig(
        title: 'File Tool - Jokita',
        description: 'Tool unggulan Jokita untuk mengelola dan memproses file tugas dengan cepat dan akurat.',
        ogImage: 'https://yourdomain.com/assets/file-tool.jpg',
        twitterImage: 'https://yourdomain.com/assets/file-tool-twitter.jpg',
        keywords: 'File tool, pengelola file tugas, platform joki, Jokita file editor',
      );

  static void setupDiagramTool() => _baseConfig(
        title: 'Diagram Tool - Jokita',
        description: 'Buat dan edit diagram dengan mudah menggunakan fitur Diagram Tool dari Jokita. Praktis untuk tugas visual.',
        ogImage: 'https://yourdomain.com/assets/diagram-tool.jpg',
        twitterImage: 'https://yourdomain.com/assets/diagram-tool-twitter.jpg',
        keywords: 'Diagram tool, buat diagram tugas, visualisasi, Jokita',
      );

  static void setupImageTool() => _baseConfig(
        title: 'Image Tool - Jokita',
        description: 'Tool untuk memodifikasi dan mengoptimalkan gambar tugas. Cocok untuk presentasi dan dokumen visual.',
        ogImage: 'https://yourdomain.com/assets/image-tool.jpg',
        twitterImage: 'https://yourdomain.com/assets/image-tool-twitter.jpg',
        keywords: 'Image tool, edit gambar tugas, optimasi gambar, Jokita',
      );

  static void setupShowcase() => _baseConfig(
        title: 'Showcase - Jokita',
        description: 'Lihat hasil karya, studi kasus, dan portfolio tugas dari para pengguna Jokita. Inspirasi dan bukti kualitas.',
        ogImage: 'https://yourdomain.com/assets/showcase.jpg',
        twitterImage: 'https://yourdomain.com/assets/showcase-twitter.jpg',
        keywords: 'Showcase Jokita, portfolio tugas, hasil kerja joki, studi kasus',
      );
}
