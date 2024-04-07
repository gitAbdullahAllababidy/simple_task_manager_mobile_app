// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../../data_layer/repositories/auth_repo.dart';
import '../../data_layer/repositories/tasks_repo.dart';
import '../../data_layer/utils/storing_tasks_util.dart';
import '../../presentation_layer/utils/current_route_util.dart';
import '../services/network_service.dart';
import '../services/secure_storage_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => CurrentRouteUtil());
  locator.registerLazySingleton(() => SecureStorageService());
  locator.registerLazySingleton(() => StoringTasksUtil());
  locator.registerFactory(() => NetworkService());
  locator.registerFactory(() => AuthRepo());
  locator.registerFactory(() => TasksRepo());
}