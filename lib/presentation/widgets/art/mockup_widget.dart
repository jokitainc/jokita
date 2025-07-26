import 'package:flutter/material.dart';
import 'dart:async';

import 'package:jokita/app/theme/colors_theme.dart';

// Impor tema aplikasi Anda jika ada, agar warnanya konsisten
// import 'theme/app_theme.dart';

// ===============================================================
// 1. WIDGET UNTUK FRAME PONSEL
// ===============================================================

class PhoneMockupWidget extends StatelessWidget {
  final Widget child; // Konten di dalam layar ponsel

  const PhoneMockupWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 360,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black, // Warna frame
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            // Konten layar
            child,
            // Notch / Dynamic Island
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================================
// 2. KONTEN DUMMY UNTUK DI DALAM PONSEL
// ===============================================================

class MockupContent extends StatelessWidget {
  final Color baseColor;

  const MockupContent({super.key, required this.baseColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll manual
        padding: const EdgeInsets.all(8.0),
        children: [
          const SizedBox(height: 16), // Spasi untuk notch
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(Icons.image, size: 50, color: Colors.white.withAlpha(70)),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: baseColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 8, color: baseColor.withAlpha(30)),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 8, color: baseColor.withAlpha(20)),
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ===============================================================
// 3. KOLOM YANG BISA SCROLL OTOMATIS
// ===============================================================
// Helper class untuk menyembunyikan scrollbar
class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
class InfiniteScrollingColumn extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final bool scrollUp; // true untuk ke atas, false untuk ke bawah

  const InfiniteScrollingColumn({
    super.key,
    required this.children,
    this.duration = const Duration(seconds: 30),
    this.scrollUp = true,
  });

  @override
  State<InfiniteScrollingColumn> createState() => _InfiniteScrollingColumnState();
}

class _InfiniteScrollingColumnState extends State<InfiniteScrollingColumn> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Mulai animasi setelah frame pertama selesai di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateScroll();
    });
  }

  void _animateScroll() async {
    // FIX: Tunggu hingga ScrollController memiliki dimensi sebelum memulai animasi.
    // Ini untuk mencegah error layout saat mencoba mengakses maxScrollExtent terlalu dini.
    while (mounted && !_scrollController.position.hasContentDimensions) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    if (!mounted) return;

    while (mounted) {
      // Tentukan posisi awal dan akhir
      final double startPosition = widget.scrollUp ? 0 : _scrollController.position.maxScrollExtent;
      final double endPosition = widget.scrollUp ? _scrollController.position.maxScrollExtent : 0;

      // Scroll ke posisi awal
      _scrollController.jumpTo(startPosition);
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      // Animasikan ke posisi akhir
      await _scrollController.animateTo(
        endPosition,
        duration: widget.duration,
        curve: Curves.linear,
      );
      
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // IgnorePointer mencegah user melakukan scroll manual pada kolom
    return ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(scrollbars: false),
      child: IgnorePointer(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.children.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: widget.children[index],
            );
          },
        ),
      ),
    );
  }
}