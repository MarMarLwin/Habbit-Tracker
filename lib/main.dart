import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/ui/onboarding/onboarding_home.dart';

import 'constants/app_assets.dart';
import 'models/front_or_back_side.dart';
import 'persistence/hive_data_store.dart';
import 'ui/theming/app_theme_manager.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppAssets.preloadSVGs();
  final dataStore = HiveDataStore();
  await dataStore.init();
  MobileAds.instance.initialize();

  //create demo tasks
  // dataStore.createDemoTasks(frontTasks: [
  //   Task.create(name: 'Cycle to Work', iconName: AppAssets.bike),
  //   Task.create(name: 'Wash Your Hands', iconName: AppAssets.washHands),
  //   Task.create(name: 'Wear a Mask', iconName: AppAssets.mask),
  //   Task.create(name: 'Brush Your Teeth', iconName: AppAssets.toothbrush),
  //   Task.create(name: 'Floss Your Teeth', iconName: AppAssets.dentalFloss),
  //   Task.create(name: 'Drink Water', iconName: AppAssets.water),
  //   Task.create(name: 'Practice Instrument', iconName: AppAssets.guitar),
  //   Task.create(name: 'Read for 10 Minutes', iconName: AppAssets.book),
  // ], backTasks: []);

  final appThemeSettings = await dataStore.appThemeSettings();

  runApp(ProviderScope(overrides: [
    dataStoreProvider.overrideWithValue(dataStore),
    appThemeManagerProvider.overrideWith((ref) => AppThemeManager(
          themeSettings: appThemeSettings,
          side: FrontOrBackSide.front,
          dataStore: dataStore,
        )),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

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
      home: const OnboardingOrHome(),
    );
  }
}
