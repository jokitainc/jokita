import 'package:flutter/material.dart';
import 'dart:math';

// ===============================================================
// HELPER CLASS UNTUK MENYIMPAN PROPERTI GELOMBANG
// ===============================================================

class _WaveProperties {
  final double amplitude;
  final double frequency;
  final double phaseShiftMultiplier;
  final int direction; // 1 untuk kanan, -1 untuk kiri

  _WaveProperties({
    required this.amplitude,
    required this.frequency,
    required this.phaseShiftMultiplier,
    required this.direction,
  });
}

// ===============================================================
// WIDGET UTAMA (WAVE DIVIDER)
// widgets/wave_divider_widget.dart
// ===============================================================

class WaveDividerWidget extends StatefulWidget {
  final double height;
  final Color color;
  final int waveCount;

  const WaveDividerWidget({
    super.key,
    this.height = 50.0,
    this.color = Colors.blue,
    this.waveCount = 3,
  });

  @override
  State<WaveDividerWidget> createState() => _WaveDividerWidgetState();
}

class _WaveDividerWidgetState extends State<WaveDividerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_WaveProperties> _waveProperties = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Inisialisasi properti acak untuk setiap gelombang
    for (int i = 0; i < widget.waveCount; i++) {
      _waveProperties.add(
        _WaveProperties(
          // Amplitudo (ketinggian) gelombang yang bervariasi
          amplitude: (widget.height / 3) + _random.nextDouble() * 10,
          // Frekuensi (kepadatan) gelombang yang bervariasi
          frequency: 1.0 + _random.nextDouble() * 0.8,
          // Pengali kecepatan yang bervariasi
          phaseShiftMultiplier: 0.8 + _random.nextDouble() * 0.4,
          // Arah gerakan acak (kiri atau kanan)
          direction: _random.nextBool() ? 1 : -1,
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Durasi sedikit lebih lama untuk gerakan yang lebih halus
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          width: double.infinity,
          child: CustomPaint(
            painter: _WavePainter(
              color: widget.color,
              animationValue: _controller.value,
              waveProperties: _waveProperties,
            ),
          ),
        );
      },
    );
  }
}

// ===============================================================
// PAINTER UNTUK MENGGAMBAR GELOMBANG
// ===============================================================

class _WavePainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final List<_WaveProperties> waveProperties;

  _WavePainter({
    required this.color,
    required this.animationValue,
    required this.waveProperties,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Gambar setiap lapisan gelombang berdasarkan properti acaknya
    for (int i = 0; i < waveProperties.length; i++) {
      // Opasitas dibuat berbeda untuk setiap lapisan untuk efek kedalaman
      final double opacity = (i + 1) / (waveProperties.length + 1);
      _drawWave(canvas, size, waveProperties[i], opacity);
    }
  }

  void _drawWave(Canvas canvas, Size size, _WaveProperties properties, double opacity) {
    final paint = Paint()..color = color.withOpacity(opacity);
    final path = Path();

    // Pergeseran fase sekarang menggunakan arah dan pengali acak
    final double phaseShift = animationValue * 2 * pi * properties.phaseShiftMultiplier * properties.direction;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      // Rumus sinus menggunakan properti unik dari setiap gelombang
      final y = sin((x / size.width * properties.frequency * 2 * pi) + phaseShift) * properties.amplitude + (size.height / 2);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}

