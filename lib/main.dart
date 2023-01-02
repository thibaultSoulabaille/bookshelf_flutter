import 'package:bookshelf/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/theme/theme_light.dart';
import 'package:bookshelf/theme/theme_dark.dart';

import 'package:bookshelf/pages/shelves.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            title: 'Bookshelf',
            theme: themeNotifier.isDark
                ? themeData(darkColorScheme)
                : themeData(lightColorScheme),
            debugShowCheckedModeBanner: false,
            home: const Shelves(),
          );
        },
      ),
    );
  }
}

ThemeData themeData(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    backgroundColor: colorScheme.background,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: colorScheme.onPrimaryContainer,
      backgroundColor: ElevationOverlay.applySurfaceTint(
          colorScheme.primaryContainer, colorScheme.surfaceTint, 3),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ElevationOverlay.applySurfaceTint(
          colorScheme.surface, colorScheme.surfaceTint, 1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      alignedDropdown: true,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: ElevationOverlay.applySurfaceTint(
          colorScheme.surface, colorScheme.surfaceTint, 1),
      // elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
        ),
      ),
      width: 360,
    ),
    listTileTheme: ListTileThemeData(
      horizontalTitleGap: 16,
      minVerticalPadding: 0,
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.only(left: 16, right: 24),
      textColor: colorScheme.onSurface,
      iconColor: colorScheme.onSurfaceVariant,
    ),
    dialogBackgroundColor: ElevationOverlay.applySurfaceTint(
        colorScheme.surface, colorScheme.surfaceTint, 3),
    dividerTheme: const DividerThemeData(
      thickness: 1,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant),
    ),
  );
}
