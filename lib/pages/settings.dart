import 'package:bookshelf/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ThemeMode { dark, light }

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeMode? _themeName = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      _themeName = themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(Icons.palette_outlined),
                title: Text('Theme'),
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Theme'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
