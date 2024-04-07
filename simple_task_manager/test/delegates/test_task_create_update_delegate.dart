import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/utils/user_authectication_util.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';
import 'package:simple_task_manager/data_layer/models/users/tasks_response_wrapper_model.dart';
import 'package:simple_task_manager/presentation_layer/views/add_update_task/add_update_task_view.dart';
import 'package:simple_task_manager/presentation_layer/views/add_update_task/delegates/add_update_task_delegate.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

// Import the generated mocks

void main() {
  late AddUpdateTaskDelegate updateTaskDelegate;
  late AddUpdateTaskDelegate addTaskDelegate;
  late MockTasksRepo mockTasksRepo;
  late MockNavigationService
      mockNavigationService; // Ensure this mock is generated

  setUp(() {
    mockTasksRepo = MockTasksRepo();
    mockNavigationService = MockNavigationService();

    // Register the mocks in the locator
    registerServices();
    addTaskDelegate =
        AddUpdateTaskDelegate(viewModel: AddUpdateTaskViewModel(null));
    updateTaskDelegate = AddUpdateTaskDelegate(
        viewModel: AddUpdateTaskViewModel(TodoResponseModel(
            completed: false, todo: "Do something", userId: 1)));

    // Assuming the form always validates for simplicity in setting up the test
    when(addTaskDelegate.formKey.currentState?.validate()).thenReturn(true);
  });

  tearDown(() {
    locator.reset();
  });

  group('AddUpdateTaskDelegate', () {
    test('addNewTask - successful', () async {
      final TodoResponseModel mockTask =
          TodoResponseModel(todo: "Do something", userId: 1, completed: false);
      when(mockTasksRepo.createNewTask(todo: mockTask))
          .thenAnswer((_) async => Right(TasksResponseWrapperModel()));
      when(UserAuthenticationUtil.getUserId())
          .thenAnswer((_) async => const Right("1"));

      await addTaskDelegate.addNewTask();

      // Verify task creation with proper parameters
      verify(mockTasksRepo.createNewTask(todo: mockTask)).called(1);
      // Verify successful navigation
      verify(mockNavigationService.back(result: anyNamed('result'))).called(1);
    });

    test('addNewTask - unsuccessful', () async {
      when(mockTasksRepo.createNewTask(todo: any))
          .thenAnswer((_) async => const Left("Error creating task"));
      when(UserAuthenticationUtil.getUserId())
          .thenAnswer((_) async => const Right("1"));

      await addTaskDelegate.addNewTask();

      // Verify task creation attempt
      verify(mockTasksRepo.createNewTask(todo: any)).called(1);
      // Verify no navigation occurs
      verifyNever(mockNavigationService.back(result: anyNamed('result')));
    });

    test('updateTask - successful', () async {
      final TodoResponseModel mockTask =
          TodoResponseModel(todo: "Updated task", userId: 1, completed: true);
      when(updateTaskDelegate.viewModel.updatableTaskModel)
          .thenReturn(mockTask);
      when(mockTasksRepo.updateTask(todo: mockTask))
          .thenAnswer((_) async => Right(TasksResponseWrapperModel()));

      await updateTaskDelegate.updateTask();

      // Verify task update with proper parameters
      verify(mockTasksRepo.updateTask(todo: any)).called(1);
      // Verify successful navigation
      verify(mockNavigationService.back(result: anyNamed('result'))).called(1);
    });

    test('updateTask - unsuccessful', () async {
      when(updateTaskDelegate.viewModel.updatableTaskModel)
          .thenReturn(TodoResponseModel());
      when(mockTasksRepo.updateTask(todo: any))
          .thenAnswer((_) async => const Left("Error updating task"));

      await updateTaskDelegate.updateTask();

      // Verify task update attempt
      verify(mockTasksRepo.updateTask(todo: any)).called(1);
      // Verify no navigation occurs
      verifyNever(mockNavigationService.back(result: anyNamed('result')));
    });
  });
}
