import 'package:bookshelf/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ThemeMode {dark, light}

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  ThemeMode? _themeName = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      _themeName = themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Theme"),
          elevation: 2,
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 16),
          children: <Widget>[
            ListTile(
              title: const Text('Dark'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: _themeName,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    _themeName = value;
                    themeNotifier.isDark = true;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Light'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: _themeName,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    _themeName = value;
                    themeNotifier.isDark = false;
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
