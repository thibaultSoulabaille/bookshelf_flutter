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
                  ? ThemeData(
                      useMaterial3: true,
                      colorScheme: darkColorScheme,
                      appBarTheme: AppBarTheme(
                        backgroundColor: darkColorScheme.surface,
                        foregroundColor: darkColorScheme.onSurface,
                      ),
                      floatingActionButtonTheme: FloatingActionButtonThemeData(
                        foregroundColor: darkColorScheme.onPrimaryContainer,
                        backgroundColor: ElevationOverlay.applySurfaceTint(
                            darkColorScheme.primaryContainer,
                            darkColorScheme.surfaceTint,
                            3),
                      ),
                      bottomSheetTheme: BottomSheetThemeData(
                        backgroundColor: ElevationOverlay.applySurfaceTint(
                            darkColorScheme.surface,
                            darkColorScheme.surfaceTint,
                            1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                      ),
                      drawerTheme: DrawerThemeData(
                        backgroundColor: ElevationOverlay.applySurfaceTint(
                            darkColorScheme.surface,
                            darkColorScheme.surfaceTint,
                            1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(28),
                          ),
                        ),
                        width: 360,
                      ),
                      listTileTheme: ListTileThemeData(
                        textColor: darkColorScheme.onSurface,
                        iconColor: darkColorScheme.onSurfaceVariant,
                        selectedColor: darkColorScheme.onSecondaryContainer,
                        selectedTileColor: darkColorScheme.secondaryContainer,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                      ),
                      dialogBackgroundColor: ElevationOverlay.applySurfaceTint(
                          darkColorScheme.surface,
                          darkColorScheme.surfaceTint,
                          3),
                      dividerColor: darkColorScheme.outline,
                      radioTheme: RadioThemeData(
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              states.contains(MaterialState.selected)
                                  ? darkColorScheme.primary
                                  : darkColorScheme.onSurfaceVariant)),
                    )
                  : ThemeData(
                      useMaterial3: true,
                      colorScheme: lightColorScheme,
                      scaffoldBackgroundColor: lightColorScheme.background,
                      appBarTheme: AppBarTheme(
                        backgroundColor: lightColorScheme.surface,
                        foregroundColor: lightColorScheme.onSurface,
                      ),
                      floatingActionButtonTheme: FloatingActionButtonThemeData(
                        foregroundColor: lightColorScheme.onPrimaryContainer,
                        backgroundColor: ElevationOverlay.applySurfaceTint(
                            lightColorScheme.primaryContainer,
                            lightColorScheme.surfaceTint,
                            3),
                      ),
                      bottomSheetTheme: BottomSheetThemeData(
                        backgroundColor: ElevationOverlay.applySurfaceTint(
                            lightColorScheme.surface,
                            lightColorScheme.surfaceTint,
                            1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                      ),
                      drawerTheme: DrawerThemeData(
                        backgroundColor: ElevationOverlay.applySurfaceTint(
                            lightColorScheme.surface,
                            lightColorScheme.surfaceTint,
                            1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(28),
                          ),
                        ),
                        width: 360,
                      ),
                      listTileTheme: ListTileThemeData(
                        textColor: lightColorScheme.onSurface,
                        iconColor: lightColorScheme.onSurfaceVariant,
                        selectedColor: lightColorScheme.onSecondaryContainer,
                        selectedTileColor: lightColorScheme.secondaryContainer,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                      ),
                      dialogBackgroundColor: ElevationOverlay.applySurfaceTint(
                          lightColorScheme.surface,
                          lightColorScheme.surfaceTint,
                          3),
                      dividerColor: lightColorScheme.outline,
                      radioTheme: RadioThemeData(
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              states.contains(MaterialState.selected)
                                  ? lightColorScheme.primary
                                  : lightColorScheme.onSurfaceVariant)),
                    ),
              debugShowCheckedModeBanner: false,
              home: const Shelves(),
            );
          },
        ));
  }
}
