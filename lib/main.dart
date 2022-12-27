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
                      backgroundColor: darkColorScheme.background,
                      scaffoldBackgroundColor: darkColorScheme.background,
                      appBarTheme: AppBarTheme(
                        backgroundColor: darkColorScheme.surface,
                        foregroundColor: darkColorScheme.onSurface,
                        elevation: 0,
                        scrolledUnderElevation: 2,
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
                        textColor: darkColorScheme.onSurface,
                        iconColor: darkColorScheme.onSurfaceVariant,
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
                      backgroundColor: lightColorScheme.background,
                      scaffoldBackgroundColor: lightColorScheme.background,
                      appBarTheme: AppBarTheme(
                        backgroundColor: lightColorScheme.surface,
                        foregroundColor: lightColorScheme.onSurface,
                        elevation: 0,
                        scrolledUnderElevation: 2,
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
                        textColor: lightColorScheme.onSurface,
                        iconColor: lightColorScheme.onSurfaceVariant,
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
