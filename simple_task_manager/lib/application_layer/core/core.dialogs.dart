// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../presentation_layer/dialogs/info_alert/info_alert_dialog.dart';


enum DialogType {
  infoAlert,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
