import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
