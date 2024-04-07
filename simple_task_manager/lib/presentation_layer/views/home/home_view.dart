import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/application_layer/utils/logout_out_util.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';
import 'package:simple_task_manager/data_layer/repositories/tasks_repo.dart';
import 'package:simple_task_manager/global/global_getters.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_view.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_viewmodel.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/data_sources/app_generic_list_data_src.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/paging_data_object.dart';
import 'package:simple_task_manager/presentation_layer/views/home/home_view_model.dart';
import 'package:stacked/stacked.dart';

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final todosListViewModel =
        useRef<AppListViewModel<TodoResponseModel>?>(null);
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (viewModel) => {},
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Stack(children: [
            Column(
              children: [
                const Gap(50),
                const HomeTitleWidget(),
                const Gap(40),
                Row(
                  children: [
                    Text(
                      "My Priority Tasks",
                      style: textThem.titleMedium
                          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const Gap(10),
                Expanded(
                    child: AppGenericListView<TodoResponseModel>(
                        paginationSettings: PagingSettings(
                          skippingAmount: 5,
                          pagingDataCallback: (pageSize, pageIndex) =>
                              locator<TasksRepo>()
                                  .loadAllTasks(
                                      skip: pageIndex, limit: pageSize)
                                  .then((value) => value.fold((l) {
                                        if (l is List<TodoResponseModel>) {
                                          return l;
                                        }
                                        return <TodoResponseModel>[];
                                      }, (r) => r.todos ?? [])),
                        ),
                        dataSrc: AppGenericListApiDataSrc(
                          apiCallback: () async {
                            return await locator<TasksRepo>()
                                .loadAllTasks()
                                .then((value) => value.fold((l) {
                                      var offlineDataRecord =
                                          (<TodoResponseModel>[], 0);
                                      if (l is List<TodoResponseModel>) {
                                        offlineDataRecord = (l, l.length);
                                      }

                                      return offlineDataRecord;
                                    }, (r) => (r.todos ?? [], r.total)));
                          },
                        ),
                        key: const ValueKey("TasksList"),
                        onCreated: (appGenericListViewModel) {
                          todosListViewModel.value = appGenericListViewModel;
                        },
                        builder: (context, data, index) =>
                            _taskWidgetBuilder(context, data))),
                const Gap(80)
              ],
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: AddNewTaskWidget(
                  onTap: () {
                    navigationService
                        .navigateToAddUpdateTaskView()
                        .then((value) {});
                  },
                ))
          ]),
        ),
      ),
    );
  }

  Widget _taskWidgetBuilder(
    BuildContext context,
    TodoResponseModel data,
  ) {
    final listViewModel =
        Provider.of<AppListViewModel<TodoResponseModel>>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return TaskItem(
      data: data,
      onDelete: (taskRef) {
        homeViewModel.deleteTaskDelegate.deleteTask(taskRef.id!,
            whenDeletedCallback: () {
          listViewModel.data.removeWhere((element) => element.id == taskRef.id);
          listViewModel.rebuildUi();
        });
      },
    );
  }
}

class HomeTitleWidget extends StatelessWidget {
  const HomeTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                Text(
                    DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY)
                        .format(DateTime.now()),
                    style: textThem.titleSmall),
              ],
            ),
            const Spacer(),
            const NotificationButtonWidget()
          ],
        ),
        const Gap(35),
        Row(
          children: [
            Text(
              "Welcome EVE",
              style: textThem.titleLarge,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Have a nice day !",
              style: textThem.bodyLarge,
            ),
          ],
        )
      ],
    );
  }
}

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: LogoutServices.showDialog,
        child: const Icon(Icons.logout_rounded));
  }
}

class AddNewTaskWidget extends StatelessWidget {
  final VoidCallback onTap;
  const AddNewTaskWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        "assets/svg/add_new_task.svg",
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final TodoResponseModel data;
  final Function(TodoResponseModel) onDelete;

  const TaskItem({super.key, required this.data, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final listViewModel =
        Provider.of<AppListViewModel<TodoResponseModel>>(context);
    return Dismissible(
      key: ValueKey(data.id ?? data.hashCode), // Ensure that the key is unique
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete(data);
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: AppColors.grayLight),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          navigationService
              .navigateToAddUpdateTaskView(updatableTaskModel: data)
              .then((value) {
            if (value != null) {
              listViewModel.runRefreshData();
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: AppColors.grayLight),
          ),
          alignment: AlignmentDirectional.centerStart,
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data.todo}",
                        style: textThem.titleMedium?.copyWith(
                            color: AppColors.brandSecondary,
                            fontWeight: FontWeight.w700,
                            decoration: (data.completed ?? false)
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  end: 0,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.grayLight),
                    onPressed: () {
                      onDelete(data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
