import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_task_manager/application_layer/core/core.dialogs.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';
import 'package:simple_task_manager/presentation_layer/utils/current_route_util.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
    setupDialogUi();
    runApp(const MainApp());
  }, (error, stack) {
    log(
      "Error",
      error: error,
      level: 0,
    );
    log("ErrorStack", stackTrace: stack, level: 1);
  });
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return MaterialApp(
        builder: (context, child) {
          child = botToastBuilder(context, child);
          return child;
        },
        initialRoute: Routes.splashView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        debugShowCheckedModeBanner: kDebugMode,
        navigatorKey: StackedService.navigatorKey,
        title: "Simple task manager",
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorObservers: [
          StackedService.routeObserver,
          locator<CurrentRouteUtil>()
        ],
        theme: appThem());
  }
}
