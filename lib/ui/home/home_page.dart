import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/common_widgets/center_svg_icon.dart';
import 'package:habit_tracker/ui/home/task_grid.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';
import 'package:hive/hive.dart';
import '../../constants/app_assets.dart';
import '../../models/task.dart';
import '../sliding_panel/sliding_panel.dart';
import '../sliding_panel/theme_selection_list.dart';
import '../theming/app_theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final leftAnimatorKey = GlobalKey<SlidingPanelAnimatorState>();
  final rightAnimatorKey = GlobalKey<SlidingPanelAnimatorState>();
  final gridAnimatorKey = GlobalKey<TaskGridState>();
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    leftAnimatorKey.currentState?.slideIn();
    rightAnimatorKey.currentState?.slideIn();
    gridAnimatorKey.currentState?.enterAnimated();
  }

  void _exitEditMode() {
    leftAnimatorKey.currentState?.slideOut();
    rightAnimatorKey.currentState?.slideOut();
    gridAnimatorKey.currentState?.exitAnimated();
  }

  @override
  Widget build(BuildContext context) {
    final datasource = ref.watch(dataStoreProvider);
    final themeSetting = ref.watch(appThemeManagerProvider);

    return AppTheme(
      data: themeSetting.themeData,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: AppTheme.of(context).primary,
            body: SafeArea(
                child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _enterEditMode,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.settings,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: datasource.frontTasksListenable(),
                      builder: (_, Box<Task> box, __) {
                        return TaskGrid(
                          key: gridAnimatorKey,
                          tasks: box.values.toList(),
                          appSetting: themeSetting,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 6,
                  left: 0,
                  width: SlidingPanel.leftPanelFixedWidth,
                  child: GestureDetector(
                    onTap: _exitEditMode,
                    child: SlidingPanelAnimator(
                      key: leftAnimatorKey,
                      direction: SlideDirection.leftToRight,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  bottom: 6,
                  right: 0,
                  width: MediaQuery.sizeOf(context).width -
                      SlidingPanel.leftPanelFixedWidth,
                  child: SlidingPanelAnimator(
                    key: rightAnimatorKey,
                    direction: SlideDirection.rightToLeft,
                    child: ThemeSelectionList(
                      currentThemeSettings: themeSetting,
                      availableWidth: MediaQuery.of(context).size.width -
                          SlidingPanel.leftPanelFixedWidth -
                          SlidingPanel.paddingWidth,
                      onColorIndexSelected: (colorIndex) => ref
                          .read(appThemeManagerProvider.notifier)
                          .updateColorIndex(colorIndex),
                      onVariantIndexSelected: (variantIndex) => ref
                          .read(appThemeManagerProvider.notifier)
                          .updateVariantIndex(variantIndex),
                    ),
                  ))
            ])),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            floatingActionButton: AnimatedOpacity(
              opacity: animationController.value,
              duration: const Duration(milliseconds: 500),
              child: FloatingActionButton(
                onPressed: () {},
                child: InkWell(
                    onTap: () {},
                    child: CenterSvgIcon(
                      iconName: AppAssets.plus,
                      color: AppTheme.of(context).primary,
                    )),
              ),
            ),
          );
        }),
      ),
    );
  }
}
