import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/data_layer/models/users/tasks_response_wrapper_model.dart';
import 'package:simple_task_manager/presentation_layer/views/home/delegates/delete_task_delegate.dart';
import 'package:simple_task_manager/presentation_layer/views/home/home_view_model.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

// Import the generated mocks

void main() {
  late DeleteTaskDelegate deleteTaskDelegate;
  late MockTasksRepo mockTasksRepo;

  setUp(() {
    mockTasksRepo = MockTasksRepo();

    // Register the mocks in the locator
    registerServices();
    deleteTaskDelegate = DeleteTaskDelegate(viewModel: HomeViewModel());
  });

  tearDown(() {
    locator.reset();
  });

  group('DeleteTaskDelegate', () {
    test('deleteTask - successful', () async {
      const int taskId = 1;
      mockWhenDeletedCallback() {}
      when(mockTasksRepo.deleteTask(taskId: anyNamed('taskId')))
          .thenAnswer((_) async => Right(TasksResponseWrapperModel()));

      await deleteTaskDelegate.deleteTask(taskId,
          whenDeletedCallback: mockWhenDeletedCallback);

      // Verify the task deletion is called
      verify(mockTasksRepo.deleteTask(taskId: taskId)).called(1);
      // Check if the callback is called
      verify(mockWhenDeletedCallback.call()).called(1);
      // Ensure no toasts or UI messages are tested here
    });

    test('deleteTask - unsuccessful', () async {
      const int taskId = 1;
      mockWhenDeletedCallback() {}
      when(mockTasksRepo.deleteTask(taskId: anyNamed('taskId')))
          .thenAnswer((_) async => const Left("Failed to delete task"));

      await deleteTaskDelegate.deleteTask(taskId,
          whenDeletedCallback: mockWhenDeletedCallback);

      // Verify the task deletion is called
      verify(mockTasksRepo.deleteTask(taskId: taskId)).called(1);
      // Check that the callback is not called on failure
      verifyNever(mockWhenDeletedCallback.call());
      // Ensure no toasts or UI messages are tested here
    });
  });
}
