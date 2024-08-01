import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/extensions/extensions.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/common_widgets/center_svg_icon.dart';
import 'package:habit_tracker/ui/home/task_grid.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';
import 'package:table_calendar/table_calendar.dart';
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
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final leftAnimatorKey = GlobalKey<SlidingPanelAnimatorState>();
  final rightAnimatorKey = GlobalKey<SlidingPanelAnimatorState>();
  final gridAnimatorKey = GlobalKey<TaskGridState>();
  final fabKey = GlobalKey<FABWidgetState>();

  late DateTime selectedDate = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    // widget.onAddOrEditTask?.call();
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
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
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    if (_animationController.value == 0) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  },
                  child: Padding(
                    padding: 8.allPadding,
                    child: Text(
                      selectedDate.ddMMMyyy,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ).bold(),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: 8.allPadding,
                          child: const Icon(
                            Icons.bar_chart,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _enterEditMode,
                        child: Padding(
                          padding: 8.allPadding,
                          child: const Icon(
                            Icons.settings,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedBuilder(
                      builder: (BuildContext context, Widget? child) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: _animationController.value,
                          child: AnimatedContainer(
                              color: Colors.white.withOpacity(0.5),
                              height: _animationController.value == 0 ? 0 : 400,
                              curve: Curves.decelerate,
                              duration: const Duration(milliseconds: 100),
                              child: child),
                        );
                      },
                      animation: _animationController,
                      child: TableCalendar(
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            // Use `selectedDayPredicate` to determine which day is currently selected.
                            // If this returns true, then `day` will be marked as selected.

                            // Using `isSameDay` is recommended to disregard
                            // the time-part of compared DateTime objects.
                            return isSameDay(selectedDate, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(selectedDate, selectedDay)) {
                              // Call `setState()` when updating the selected day
                              setState(() {
                                selectedDate = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              _animationController.reverse();
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          firstDay:
                              DateTime.now().subtract(const Duration(days: 60)),
                          lastDay:
                              DateTime.now().add(const Duration(days: 60)))),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: datasource.tasksListenable(),
                      builder: (_, Box<Task> box, __) {
                        return TaskGrid(
                          key: gridAnimatorKey,
                          tasks: box.values
                              .where((x) =>
                                  x.createDate.ddMMMyyy ==
                                  selectedDate.ddMMMyyy)
                              .toList(),
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
                  )),
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
