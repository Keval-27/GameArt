import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'premium_screen.dart';
import '../theme/theme_provider.dart';
import '../services/favorites_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final favs = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          // PREMIUM TILE
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: Colors.amber.shade50,
            child: ListTile(
              leading: const Icon(Icons.star, color: Colors.orangeAccent),
              title: const Text(
                'Go Premium',
                style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),
              ),
              subtitle: const Text('Remove ads and unlock all 4K wallpapers' , style: TextStyle(color: Colors.black),),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const PremiumScreen()),
                );

                // Optional: react to success
                if (result == true) {
                  // e.g. refresh premium flag or just setState()
                  // setState(() {});
                }
              }
              ,
            ),
          ),

          const Divider(),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(theme.mode.name.toUpperCase()),
            trailing: const Icon(Icons.color_lens_outlined),
            onTap: () => _showThemeSheet(context),
          ),
          const Divider(),
          ListTile(
            title: const Text('Favourites count'),
            subtitle: Text('${favs.ids.length} items'),
            leading: const Icon(Icons.favorite),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showThemeSheet(BuildContext context) {
    final theme = context.read<ThemeProvider>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Light'),
              value: AppThemeMode.light,
              groupValue: theme.mode,
              onChanged: (v) => theme.setMode(v!),
            ),
            RadioListTile(
              title: const Text('Dark'),
              value: AppThemeMode.dark,
              groupValue: theme.mode,
              onChanged: (v) => theme.setMode(v!),
            ),
            RadioListTile(
              title: const Text('AMOLED'),
              value: AppThemeMode.amoled,
              groupValue: theme.mode,
              onChanged: (v) => theme.setMode(v!),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
