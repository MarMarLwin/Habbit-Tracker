import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/ui/home/home_page.dart';
import 'package:habit_tracker/ui/onboarding/on_boarding.dart';
import 'package:hive/hive.dart';

import '../../persistence/hive_data_store.dart';

class OnboardingOrHome extends ConsumerWidget {
  const OnboardingOrHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datasource = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
        valueListenable: datasource.didAddFirstTaskListenable(),
        builder: (_, Box<bool> box, __) {
          return datasource.didAddFirstTask(box)
              ? const HomePage()
              : const OnBoarding();
        });
  }
}
