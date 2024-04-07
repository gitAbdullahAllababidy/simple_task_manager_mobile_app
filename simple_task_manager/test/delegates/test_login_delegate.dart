import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/data_layer/models/res/auth/auth_response_model.dart';
import 'package:simple_task_manager/presentation_layer/views/login/delegates/login_delegate.dart';
import 'package:simple_task_manager/presentation_layer/views/login/login_view.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';



void main() {
  late LoginDelegate loginDelegate;
  late MockAuthRepo mockAuthRepo;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockAuthRepo = locator<MockAuthRepo>();
    mockNavigationService = locator<MockNavigationService>();

    loginDelegate = LoginDelegate(viewModel: LoginViewModel());
    loginDelegate.emailCOntroller.text = 'kminchelle';
    loginDelegate.passwordController.text = '0lelplR';

    // Mock the authentication response
    when(mockAuthRepo.loginUser(any)).thenAnswer(
        (_) => Future.value(const Right(AuthResponseModel(token: 'token'))));

    // Mock the navigation service
    when(mockNavigationService.clearStackAndShow(any)).thenReturn(null);

    // Register the mocks in the locator
    registerServices();
  });

  group('LoginDelegate', () {
    test('loginUser - valid credentials', () async {
      // Call loginUser method
      await loginDelegate.loginUser();

      // Verify the successful navigation after authentication
      verify(mockNavigationService.clearStackAndShow(any));
    });

    test('loginUser - invalid credentials', () async {
      // Mock invalid authentication response
      when(mockAuthRepo.loginUser(any))
          .thenAnswer((_) => Future.value(const Left('Invalid credentials')));

      // Call loginUser method
      await loginDelegate.loginUser();

      // Verify that no navigation occurs
      verifyNever(mockNavigationService.clearStackAndShow(any));
    });
  });
}
