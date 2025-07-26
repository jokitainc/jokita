import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jokita/app/theme/colors_theme.dart';
import 'package:jokita/presentation/widgets/art/mockup_widget.dart';
import 'package:jokita/presentation/widgets/global/footer_widget.dart';
import 'package:jokita/presentation/widgets/global/layout_widget.dart';
import 'package:jokita/presentation/widgets/global/navbar_widget.dart';
import 'package:jokita/presentation/widgets/section/wave_divider_widget.dart';

@RoutePage()
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Siapkan konten dummy untuk setiap ponsel
    final List<Widget> mockupContents = [
      MockupContent(baseColor: AppColors.primary50),
      MockupContent(baseColor: AppColors.tertiary50),
      MockupContent(baseColor: AppColors.secondary50),
      MockupContent(baseColor: AppColors.secondary30),
      MockupContent(baseColor: AppColors.primary20),
    ];
    
    // Bungkus setiap konten dengan frame ponsel
    final List<Widget> phoneMockups = mockupContents
        .map((content) => PhoneMockupWidget(child: content))
        .toList();
        
    return LayoutWidget(
      appBar: const NavbarWidget(),
      drawer: const AppDrawer(),
      footer: FooterWidget(),
      content: Column(
        children: [
          const SizedBox(height: 40),
          WaveDividerWidget(
            height: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Jokita!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          CarouselSlider(
            options: CarouselOptions(height: 400.0),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.amber),
                    child: Text('text $i', style: const TextStyle(fontSize: 16.0)),
                  );
                },
              );
            }).toList(),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              // Atur breakpoint, misalnya 600 piksel
              if (constraints.maxWidth > 800) {
                // Tampilan desktop (Row)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 500,
                      child: InfiniteScrollingColumn(
                        scrollUp: true,
                        duration: const Duration(seconds: 100),
                        children: phoneMockups,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 200,
                      height: 500,
                      child: InfiniteScrollingColumn(
                        scrollUp: false,
                        duration: const Duration(seconds: 100),
                        children: [...phoneMockups].reversed.toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 200,
                      height: 500,
                      child: InfiniteScrollingColumn(
                        scrollUp: true,
                        duration: const Duration(seconds: 100),
                        children: phoneMockups.sublist(0, phoneMockups.length - 1),
                      ),
                    ),
                  ],
                );
              } else {
                // Tampilan mobile (Column)
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180, // Lebar disesuaikan untuk mobile
                        height: 300,
                        child: InfiniteScrollingColumn(
                          scrollUp: true,
                          duration: const Duration(seconds: 25),
                          children: phoneMockups,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 180,
                        height: 300,
                        child: InfiniteScrollingColumn(
                          scrollUp: false,
                          duration: const Duration(seconds: 30),
                          children: [...phoneMockups].reversed.toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          ElevatedButton(
            onPressed: () {
              AutoRouter.of(context).pushPath('/showcase');
            },
            child: const Text('Go to Sign In'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}