import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jokita/app/const/breakpoint.dart';
import 'package:jokita/app/theme/colors_theme.dart';
import 'package:jokita/presentation/widgets/input/search_menu_widget.dart';
import 'package:jokita/presentation/widgets/logo/logo_primary_widget.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return _buildMobileAppBar(context);
        } else if (constraints.maxWidth < 600) {
          return _buildFoldableAppBar(context);
        } else if (constraints.maxWidth < 900) {
          return _buildTabletAppBar(context);
        } else {
          return _buildDesktopAppBar(context);
        }
      },
    );
  }

  AppBar _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: LogoPrimaryWidget(),
      backgroundColor: AppColors.primary40,
      automaticallyImplyLeading: false,
      centerTitle: false,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  AppBar _buildFoldableAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary40,
      title: LogoPrimaryWidget(),
      automaticallyImplyLeading: false,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  AppBar _buildTabletAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary40,
      title: LogoPrimaryWidget(),
      automaticallyImplyLeading: false,
      centerTitle: false,
      flexibleSpace: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: const SearchMenuWidget(),
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primary40,
        border: Border(bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(Icons.flutter_dash, size: 30, color: Colors.blueAccent),
              const SizedBox(width: 12),
              const Text('Jokita', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
            ],
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: const SearchMenuWidget(),
              ),
            ),
          ),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.end,
            children: [
              PopupMenuButton<String>(
                offset: const Offset(80, 30),
                color: AppColors.primary40,
                onSelected: (value) => _handleMenuSelection(context, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'docs_converter', child: Text('Docs Converter', style: TextStyle(color: AppColors.white))),
                  const PopupMenuItem(value: 'image_converter', child: Text('Image Converter', style: TextStyle(color: AppColors.white))),
                ],
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(children: [Text('Features', style: theme.textTheme.titleMedium?.copyWith(color: AppColors.white)), const Icon(Icons.arrow_drop_down, color: AppColors.white)]),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('About', style: TextStyle(color: AppColors.white))),
              TextButton(onPressed: () => AutoRouter.of(context).pushPath('/signin'), child: const Text('Sign In', style: TextStyle(color: AppColors.white))),
              ElevatedButton.icon(
                onPressed: () => _handleMenuSelection(context, 'download'),
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: $value')),
     );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8.0);
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text('Jokita Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          if (screenWidth < 600)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchMenuWidget(),
            ),
          if (screenWidth < 900) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign In'),
              onTap: () {
                Navigator.pop(context);
                AutoRouter.of(context).pushPath('/signin');
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.star),
              title: const Text('Features'),
              children: <Widget>[
                ListTile(
                  title: const Text('Docs Converter'),
                  onTap: () => _handleMenuSelection(context, 'docs_converter'),
                ),
                ListTile(
                  title: const Text('Image Converter'),
                  onTap: () => _handleMenuSelection(context, 'image_converter'),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _handleMenuSelection(context, 'about'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download App'),
              onTap: () => _handleMenuSelection(context, 'download'),
            ),
          ],
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
     Navigator.pop(context);
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: $value')),
     );
  }
}