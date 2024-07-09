import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/persistence/hive_data_store.dart';
import 'package:habbit_tracker/ui/common_widgets/center_svg_icon.dart';
import 'package:habbit_tracker/ui/home/task_grid.dart';
import 'package:hive/hive.dart';
import '../../constants/app_assets.dart';
import '../../models/task.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final datasource = ref.watch(dataStoreProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xffb274b9),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: datasource.frontTasksListenable(),
                builder: (_, Box<Task> box, __) {
                  return TaskGrid(tasks: box.values.toList());
                },
              ),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: InkWell(
              onTap: () {},
              child: const CenterSvgIcon(
                iconName: AppAssets.plus,
                color: Colors.purple,
              )),
        ),
      ),
    );
  }
}
