
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:jokita/presentation/widgets/art/mockup_widget.dart';

@RoutePage()
class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Siapkan konten dummy untuk setiap ponsel
    final List<Widget> mockupContents = [
      MockupContent(baseColor: theme.colorScheme.primary),
      MockupContent(baseColor: theme.colorScheme.secondary),
      // FIX: Memperbaiki kesalahan ketik dari MockpContent menjadi MockupContent
      MockupContent(baseColor: Colors.teal),
      MockupContent(baseColor: Colors.orange),
      MockupContent(baseColor: theme.colorScheme.error),
    ];
    
    // Bungkus setiap konten dengan frame ponsel
    final List<Widget> phoneMockups = mockupContents
        .map((content) => PhoneMockupWidget(child: content))
        .toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Row(
          children: [
            // Kolom 1 (bergerak ke atas)
              // Kolom 1 (bergerak ke atas)
            Container(
              width: 200,
              height: 500,
              child: InfiniteScrollingColumn(
                scrollUp: true,
                duration: const Duration(seconds: 25),
                children: phoneMockups,
              ),
            ),
            SizedBox(width: 16),
            // Kolom 2 (bergerak ke bawah)
              // Kolom 1 (bergerak ke atas)
            Container(
              width: 200,
              height: 500,
              child: InfiniteScrollingColumn(
                scrollUp: false,
                duration: const Duration(seconds: 30),
                children: [...phoneMockups].reversed.toList(),
              ),
            ),
            SizedBox(width: 16),
            // Kolom 3 (bergerak ke atas)
              // Kolom 1 (bergerak ke atas)
            Container(
              width: 200,
              height: 500,
              child: InfiniteScrollingColumn(
                scrollUp: true,
                duration: const Duration(seconds: 28),
                children: phoneMockups,
              ),
            ),
          ],
        ),
      ),
    );
  }
}