import 'package:flutter/material.dart';
import 'package:bookshelf/pages/themeSettings.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 2,
      ),
      body: ListView(
        // padding: const EdgeInsets.only(top: 16),
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.only(left: 16, top: 12, right: 24, bottom: 12),
            leading: const Icon(Icons.palette_rounded),
            title: const Text('Theme'),
            subtitle: const Text('change application theme'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeSettings(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
