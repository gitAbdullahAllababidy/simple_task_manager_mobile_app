import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/services/network_service.dart';
import 'package:simple_task_manager/application_layer/services/secure_storage_service.dart';
import 'package:simple_task_manager/data_layer/repositories/auth_repo.dart';
import 'package:simple_task_manager/data_layer/repositories/tasks_repo.dart';
import 'package:simple_task_manager/data_layer/utils/storing_tasks_util.dart';
import 'package:stacked_services/stacked_services.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<NetworkService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthRepo>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<TasksRepo>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SecureStorageService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<StoringTasksUtil>(onMissingStub: OnMissingStub.returnDefault),
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterNetworkService();
  getAndRegisterAuthRepo();
  getAndRegisterTasksRepo();
  getAndRegisterSecureStorageService();
  getAndRegisterStoringTasksUtil();
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockNetworkService getAndRegisterNetworkService() {
  _removeRegistrationIfExists<NetworkService>();
  final service = MockNetworkService();
  locator.registerSingleton<NetworkService>(service);
  return service;
}

MockAuthRepo getAndRegisterAuthRepo() {
  _removeRegistrationIfExists<AuthRepo>();
  final service = MockAuthRepo();
  locator.registerSingleton<AuthRepo>(service);
  return service;
}

MockTasksRepo getAndRegisterTasksRepo() {
  _removeRegistrationIfExists<TasksRepo>();
  final service = MockTasksRepo();
  locator.registerSingleton<TasksRepo>(service);
  return service;
}

MockSecureStorageService getAndRegisterSecureStorageService() {
  _removeRegistrationIfExists<SecureStorageService>();
  final service = MockSecureStorageService();
  locator.registerSingleton<SecureStorageService>(service);
  return service;
}

MockStoringTasksUtil getAndRegisterStoringTasksUtil() {
  _removeRegistrationIfExists<StoringTasksUtil>();
  final service = MockStoringTasksUtil();
  locator.registerSingleton<StoringTasksUtil>(service);
  return service;
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
