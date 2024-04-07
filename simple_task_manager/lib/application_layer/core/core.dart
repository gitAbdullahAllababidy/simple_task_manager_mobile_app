import 'package:simple_task_manager/application_layer/services/network_service.dart';
import 'package:simple_task_manager/application_layer/services/secure_storage_service.dart';
import 'package:simple_task_manager/data_layer/repositories/auth_repo.dart';
import 'package:simple_task_manager/data_layer/repositories/tasks_repo.dart';
import 'package:simple_task_manager/data_layer/utils/storing_tasks_util.dart';
import 'package:simple_task_manager/presentation_layer/dialogs/info_alert/info_alert_dialog.dart';
import 'package:simple_task_manager/presentation_layer/utils/current_route_util.dart';
import 'package:simple_task_manager/presentation_layer/views/add_update_task/add_update_task_view.dart';
import 'package:simple_task_manager/presentation_layer/views/home/home_view.dart';
import 'package:simple_task_manager/presentation_layer/views/login/login_view.dart';
import 'package:simple_task_manager/presentation_layer/views/register/register_view.dart';
import 'package:simple_task_manager/presentation_layer/views/splash/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// @stacked-import

@StackedApp(routes: [
  AdaptiveRoute(page: SplashView),
  AdaptiveRoute(page: RegisterView),
  AdaptiveRoute(page: LoginView),
  AdaptiveRoute(page: Home),
  AdaptiveRoute(page: AddUpdateTaskView),
], dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: CurrentRouteUtil),
  LazySingleton(classType: SecureStorageService),
  LazySingleton(classType: StoringTasksUtil),
  Factory(classType: NetworkService),
  Factory(classType: AuthRepo),
  Factory(classType: TasksRepo),

  // @stacked-service
], dialogs: [
  StackedDialog(classType: InfoAlertDialog),
])
class App {
  static const devSettings = (EAppEnv.dev, "https://dummyjson.com");
}

enum EAppEnv {
  dev('dev');

  final String title;
  const EAppEnv(this.title);
}
