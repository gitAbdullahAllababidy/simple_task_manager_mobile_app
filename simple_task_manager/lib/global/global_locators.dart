import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/data_layer/utils/storing_tasks_util.dart';
import 'package:simple_task_manager/presentation_layer/utils/current_route_util.dart';
import 'package:stacked_services/stacked_services.dart';

NavigationService navigationService = locator<NavigationService>();

CurrentRouteUtil currentRouteUtil = locator<CurrentRouteUtil>();
DialogService dialogService = locator<DialogService>();
StoringTasksUtil storingTasksUtil = locator<StoringTasksUtil>();
