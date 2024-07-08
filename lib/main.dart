import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/ui/home/home_page.dart';

import 'constants/app_assets.dart';
import 'models/front_or_back_side.dart';
import 'persistence/hive_data_store.dart';
import 'ui/theming/app_theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAssets.preloadSVGs();
  final dataStore = HiveDataStore();
  await dataStore.init();

  final frontThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.front);
  final backThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.back);
  runApp(ProviderScope(overrides: [
    dataStoreProvider.overrideWithValue(dataStore),
    frontThemeManagerProvider.overrideWith((ref) => AppThemeManager(
          themeSettings: frontThemeSettings,
          side: FrontOrBackSide.front,
          dataStore: dataStore,
        )),
    backThemeManagerProvider.overrideWith((ref) => AppThemeManager(
          themeSettings: backThemeSettings,
          side: FrontOrBackSide.back,
          dataStore: dataStore,
        )),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: 'Helvetica Neue',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: const HomePage(),
    );
  }
}
