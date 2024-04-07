import 'package:flutter/material.dart';


final class DataCountInfoSettings {
  /// This class is used to configure how data count information is displayed
  /// in a UI component. It allows customization of the widget used to display
  /// the data count information and whether the information should be shown.

  /// A callback function that returns a [Widget] to display data count information.
  ///
  /// The function is passed two parameters: `totalAvailableDataCount` and `loadedDataCount`.
  /// - `totalAvailableDataCount` is an [int?] representing the total number of data items available.
  ///   This can be null if the total count is unknown.
  /// - `loadedDataCount` is an [int] representing the number of data items currently loaded.
  ///
  /// The function should return a [Widget] that appropriately displays these counts.
  /// If null, no custom widget is used, and the default representation is shown.
  final Widget Function(int? totalAvailableDataCount, int loadedDataCount)?
      dataCountWidgetCallback;

  /// A flag to control the visibility of the data count information.
  ///
  /// If [true], the data count information is shown. If [false], it is hidden.
  /// The default value is [true], meaning the data count information is shown by default.
  final bool show;

  /// Creates an instance of [DataCountInfoSettings].
  ///
  /// - [dataCountWidgetCallback] allows specifying a custom widget for displaying
  ///   data count information. If not provided, a default representation is used.
  /// - [show] can be used to control the visibility of the data count information.
  ///   By default, it is set to [true], showing the information.
  const DataCountInfoSettings({this.dataCountWidgetCallback, this.show = false});

  static Widget dataCountDefaultWidgetBuilder(
          {required int loadedDataCount,
          required int? totalAvailableDataCount}) =>
      totalAvailableDataCount != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                      "Loaded $loadedDataCount from $totalAvailableDataCount"),
                ),
              ],
            )
          : const SizedBox();
}
