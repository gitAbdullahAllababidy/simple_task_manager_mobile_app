import 'package:flutter/material.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/data_sources/app_generic_list_data_src.dart';


class RefreshSetting<T> {
  final Key? key;

  /// The amount of displacement when the refresh is activated.
  /// Defaults to 40.0.
  final double displacement;

  /// The offset at which the refresh indicator can be triggered.
  /// Defaults to 0.0.
  final double edgeOffset;

  /// The color of the refresh indicator's progress indicator.
  /// Defaults to the primary color of the theme.
  final Color? color;

  /// The background color of the refresh indicator.
  /// Defaults to null.
  final Color? backgroundColor;

  /// A function that decides whether a particular [ScrollNotification]
  /// should be considered for triggering a refresh.
  ///
  /// By default, this function returns `true` if the notification
  /// is of type [ScrollEndNotification] and the notification's
  /// depth is zero (i.e. at the top of the scrollable).
  final bool Function(ScrollNotification) notificationPredicate;

  /// The semantic label for the refresh indicator.
  /// This is used by accessibility tools to announce the presence
  /// and current state of the refresh indicator to the user.
  final String? semanticsLabel;

  /// The semantic value of the refresh indicator.
  /// This can be used to provide more context for accessibility tools.
  final String? semanticsValue;

  /// The stroke width of the progress indicator in logical pixels.
  /// Defaults to the stroke width of [RefreshProgressIndicator.defaultStrokeWidth].
  final double strokeWidth;

  /// The trigger mode for the refresh indicator.
  ///
  /// Controls how a refresh can be initiated.
  /// Defaults to [RefreshIndicatorTriggerMode.onEdge].
  final RefreshIndicatorTriggerMode triggerMode;
  final Future<AppGenericListDataSrcType<T>> Function() refreshDataCallback;
  RefreshSetting({
    this.key,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.color = Colors.blue,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    required this.refreshDataCallback,
  });


}