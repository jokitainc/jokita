import 'package:flutter/material.dart';
import 'package:jokita/app/const/breakpoint.dart';

/// A reusable layout widget that provides a consistent structure
/// with an optional AppBar, a main content area, and an optional footer
/// that always sticks to the bottom of the screen.
class LayoutWidget extends StatelessWidget {
  /// The app bar to display at the top of the screen.
  final PreferredSizeWidget? appBar;

  /// The main content to display in the body. This content will be scrollable
  /// if it overflows.
  final Widget content;
  final Widget? drawer;

  /// The footer to display at the bottom of the screen.
  final Widget? footer;

  const LayoutWidget({
    super.key,
    this.appBar,
    required this.content,
    this.footer,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    // Cek lebar layar untuk menentukan posisi drawer
    final isMobile = MediaQuery.of(context).size.width < Breakpoint.bMobile;

    return Scaffold(
      appBar: appBar,
      // Gunakan drawer untuk desktop dan endDrawer untuk mobile
      drawer: !isMobile ? drawer : null,
      endDrawer: isMobile ? drawer : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              content,
              if (footer != null) footer!,
            ],
          ),
        ),
      ),
    );
  }
}
