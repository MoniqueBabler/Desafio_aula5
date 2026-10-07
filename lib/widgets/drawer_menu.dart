import 'package:flutter/material.dart';

import '../ui/splash.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const DrawerMenu({
    super.key,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB), // Azul
                  Color(0xFF7C3AED), // Roxo
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SwitchListTile(
            activeThumbColor: Color(0xFF7C3AED),
            title: const Text("Tema escuro"),
            value: isDark,
            onChanged: (_) => onToggleTheme(),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color(0xFF2563EB),
            ),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(
              Icons.directions_walk,
              color: Color(0xFF7C3AED),
            ),
            title: const Text('Splash'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => Splash(
                    onToggleTheme: onToggleTheme,
                  ),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}