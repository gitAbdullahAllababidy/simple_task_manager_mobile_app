import 'package:flutter/material.dart';
import 'package:simple_task_manager/presentation_layer/utils/loading_utils.dart';

/// Defines a type for a record that takes two arguments:
///  * `items`: A list of data of type `T`.
///  * `totalDataAmountReturnedFromServer`: An optional integer representing
///    the total amount of data returned from the server,
///    or null if this information is unavailable.
typedef AppGenericListDataSrcType<T> = (
  List<T> items,
  int? totalDataAmountReturnedFromServer,
);

final class AppGenericListDataSrc {
  final String persistentId;

  AppGenericListDataSrc({this.persistentId = ""});
}

final class AppGenericListApiDataSrc<T> extends AppGenericListDataSrc {
  final Future<AppGenericListDataSrcType<T>> Function() apiCallback;
  final Widget loadingWidget;
  AppGenericListApiDataSrc({
    required this.apiCallback,
    super.persistentId,
  }) : loadingWidget = appLoaderWidget();
}

final class AppGenericListLocalDataSrc<T> extends AppGenericListDataSrc {
  final List<T> initialData;
  AppGenericListLocalDataSrc({required this.initialData, super.persistentId});
}
