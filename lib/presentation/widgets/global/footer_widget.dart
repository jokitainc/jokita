import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jokita/app/theme/colors_theme.dart';
// Untuk representasi ikon yang lebih akurat seperti GitHub dan LinkedIn,
// Anda mungkin ingin menambahkan paket font_awesome_flutter ke pubspec.yaml Anda
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Model untuk merepresentasikan satu partikel yang bergerak.
class _Particle {
  Offset position;
  Offset speed;

  _Particle({required this.position, required this.speed});

  /// Memperbarui posisi partikel berdasarkan kecepatannya dan batas-batas canvas.
  void update(Size bounds) {
    position += speed;
    if (position.dx < 0 || position.dx > bounds.width) {
      speed = Offset(-speed.dx, speed.dy);
    }
    if (position.dy < 0 || position.dy > bounds.height) {
      speed = Offset(speed.dx, -speed.dy);
    }
  }
}

/// Widget yang menampilkan animasi garis-garis abstrak di latar belakang.
class AnimatedLinesBackground extends StatefulWidget {
  const AnimatedLinesBackground({super.key});

  @override
  State<AnimatedLinesBackground> createState() =>
      _AnimatedLinesBackgroundState();
}

class _AnimatedLinesBackgroundState extends State<AnimatedLinesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();
  final int _particleCount = 50; // Jumlah partikel

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() {
            setState(() {});
          });

    // Menunggu frame pertama untuk mendapatkan ukuran widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeParticles(context.size ?? const Size(400, 200));
      _controller.repeat();
    });
  }

  void _initializeParticles(Size size) {
    if (!mounted || size.isEmpty) return;
    _particles.clear();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        _Particle(
          position: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          speed: Offset(
            (_random.nextDouble() - 0.5) * 0.5,
            (_random.nextDouble() - 0.5) * 0.5,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinesPainter(particles: _particles),
      child: Container(),
    );
  }
}

class _LinesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double _maxDistance = 100.0;

  _LinesPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;

    for (final particle in particles) {
      particle.update(size);
    }

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];
        final distance = (p1.position - p2.position).distance;

        if (distance < _maxDistance) {
          final opacity = 10 - (distance / _maxDistance);
          paint.color = AppColors.white.withAlpha((opacity * 10).toInt());
          canvas.drawLine(p1.position, p2.position, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: const Color(0xFF111827), // bg-gray-900
            child: const AnimatedLinesBackground(),
          ),
        ),
        // Konten footer asli
        Container(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          color: AppColors.primary50.withAlpha(70),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 768;
        
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bagian konten utama
                    isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                    const SizedBox(height: 32), // mt-8
        
                    const Divider(
                      color: Color(0xFF1F2937),
                    ), // border-t border-gray-800
                    const SizedBox(height: 32), // pt-8
                    Text(
                      '© ${DateTime.now().year} FlutterCorp. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ), // text-gray-400
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Layout untuk layar yang lebih lebar (desktop).
  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 2, child: _LogoAndDescription()),
          const Spacer(),
          Expanded(
            child: _LinksColumn(
              title: 'Services',
              links: const [
                'Mobile Development',
                'Web Applications',
                'Desktop Apps',
                'Consulting',
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: _LinksColumn(
              title: 'Company',
              links: const ['About Us', 'Portfolio', 'Careers', 'Contact'],
            ),
          ),
          const Spacer(),
          const Expanded(child: _ConnectSection()),
        ],
      ),
    );
  }

  /// Layout untuk layar yang lebih sempit (mobile).
  Widget _buildMobileLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LogoAndDescription(),
        const SizedBox(height: 32),
        _LinksColumn(
          title: 'Services',
          links: const [
            'Mobile Development',
            'Web Applications',
            'Desktop Apps',
            'Consulting',
          ],
        ),
        const SizedBox(height: 32),
        _LinksColumn(
          title: 'Company',
          links: const ['About Us', 'Portfolio', 'Careers', 'Contact'],
        ),
        const SizedBox(height: 32),
        const _ConnectSection(),
      ],
    );
  }
}

/// Bagian logo, nama, dan deskripsi.
class _LogoAndDescription extends StatelessWidget {
  const _LogoAndDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon logo
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF6B21A8),
                  ], // from-purple-600 to-purple-800
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
              ),
              child: const Icon(
                Icons.code, // Placeholder untuk ikon 'Code'
                color: AppColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            // Nama perusahaan
            const Text(
              'JokitaCorp',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Text(
          'Solusi digital terpercaya untuk para profesional.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Teks deskripsi
        const Text(
          'Kami membantu Anda menyelesaikan proyek client dengan cepat, transparan, dan terintegrasi tanpa kompromi dalam keamanan dan privasi. \nBekerja lebih cerdas, bukan lebih keras. \nBangun reputasi Anda, biarkan kami tangani sisanya',
          style: TextStyle(color: Color(0xFF6B7280)),
          textAlign: TextAlign.justify, // text-gray-400
        ),
      ],
    );
  }
}

/// Kolom tautan teks dengan judul.
class _LinksColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _LinksColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul bagian
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600, // font-semibold
          ),
        ),
        const SizedBox(height: 16), // mb-4
        // Daftar tautan
        ...links.map(
          (linkText) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // space-y-2
            child: _FooterLink(text: linkText),
          ),
        ),
      ],
    );
  }
}

/// Satu tautan teks yang dapat diklik untuk footer.
class _FooterLink extends StatefulWidget {
  final String text;
  const _FooterLink({required this.text});

  @override
  _FooterLinkState createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Tangani event klik tautan
          print('${widget.text} diklik!');
        },
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isHovered
                ? AppColors.white
                : const Color(0xFF6B7280), // hover:text-white
          ),
        ),
      ),
    );
  }
}

/// Bagian "Connect" dengan ikon media sosial.
class _ConnectSection extends StatelessWidget {
  const _ConnectSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connect',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SocialIconButton(
              // Menggunakan ikon placeholder. Untuk GitHub, pertimbangkan `FontAwesomeIcons.github`.
              icon: Icons.link,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            _SocialIconButton(
              // Menggunakan ikon placeholder. Untuk Twitter, pertimbangkan `FontAwesomeIcons.twitter`.
              icon: Icons.chat_bubble_outline,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            _SocialIconButton(
              // Menggunakan ikon placeholder. Untuk LinkedIn, pertimbangkan `FontAwesomeIcons.linkedin`.
              icon: Icons.business_center_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

/// Tombol ikon bergaya untuk tautan media sosial.
class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialIconButton({required this.icon, required this.onPressed});

  @override
  __SocialIconButtonState createState() => __SocialIconButtonState();
}

class __SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Icon(
          widget.icon,
          size: 24,
          color: _isHovered ? AppColors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
