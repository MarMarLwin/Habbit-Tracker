// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/ui/add_task/task_detail_page.dart';
import 'package:habit_tracker/ui/common_widgets/arc_painter.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/common_widgets/center_svg_icon.dart';
import 'package:habit_tracker/ui/home/task_grid.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/task.dart';
import '../add_task/add_task_navigator.dart';
import '../sliding_panel/sliding_panel.dart';
import '../sliding_panel/theme_selection_list.dart';
import '../theming/app_theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final leftAnimatorKey = GlobalKey<SlidingPanelAnimatorState>();
  final rightAnimatorKey = GlobalKey<SlidingPanelAnimatorState>();
  final gridAnimatorKey = GlobalKey<TaskGridState>();
  final fabKey = GlobalKey<FABWidgetState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _enterEditMode() {
    leftAnimatorKey.currentState?.slideIn();
    rightAnimatorKey.currentState?.slideIn();
    gridAnimatorKey.currentState?.enterAnimated();
    fabKey.currentState?.enterAnimated();
  }

  void _exitEditMode() {
    leftAnimatorKey.currentState?.slideOut();
    rightAnimatorKey.currentState?.slideOut();
    gridAnimatorKey.currentState?.exitAnimated();
    fabKey.currentState?.exitAnimated();
  }

  Future<void> _addNewTask(WidgetRef ref, AppThemeData appThemeData) async {
    // * Notify the parent widget that we need to exit the edit mode
    // * As a result, the parent widget will call exitEditMode() and
    // * the edit UI will be dismissed
    // widget.onAddOrEditTask?.call();
    // * Short delay to wait for the animations to complete
    await Future.delayed(const Duration(milliseconds: 200));
    // ignore_for_file:use_build_context_synchronously

    debugPrint('add.....');
    // * then, show the Add Task page
    await showCupertinoModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.black50,
      builder: (_) => AppTheme(
        data: appThemeData,
        child: const AddTaskNavigator(),
      ),
    );
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
                      valueListenable: datasource.tasksListenable(),
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
            floatingActionButton: FABWidget(
              key: fabKey,
              onPressed: () => _addNewTask(ref, themeSetting.themeData),
            ),
          );
        }),
      ),
    );
  }
}

class FABWidget extends StatefulWidget {
  const FABWidget({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;

  @override
  State<FABWidget> createState() => FABWidgetState();
}

class FABWidgetState extends State<FABWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.forward();
  }

  void enterAnimated() {
    _animationController.reverse();
  }

  void exitAnimated() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedOpacity(
            opacity: _animationController.value,
            duration: const Duration(milliseconds: 500),
            child: child);
      },
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        child: InkWell(
            onTap: widget.onPressed,
            child: CenterSvgIcon(
              iconName: AppAssets.plus,
              color: AppTheme.of(context).primary,
            )),
      ),
    );
  }
}
