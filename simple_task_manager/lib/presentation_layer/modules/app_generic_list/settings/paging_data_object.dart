import 'package:flutter/material.dart';

final class PagingSettings<T> {
  /// A function that asynchronously fetches and returns a list of type [T] for a given page size and index.
  final Future<List<T>> Function(int pageSize, int whereToStartPagingIndexing)
      pagingDataCallback;

  final int skippingAmount;

  int calculatedSkipping;

  /// The value of animation offset after loading new data, represented as a double.
  final double animationOffsetValueAfterLoadingNewData;

  /// The mode of insertion for new data during pagination.
  final PagingInsertionMode pagingInsertionMode;

  /// The widget to display while loading more data during pagination.
  final Widget? pagingLoadingMoreWidget;

  ///Tost message showed in case of no more data loaded after paging call
  String? noMoreDataMessage;

  ///

  PagingSettings(
      {this.pagingInsertionMode = PagingInsertionMode.addMode,
      this.pagingLoadingMoreWidget,
      this.animationOffsetValueAfterLoadingNewData = 100,
      this.noMoreDataMessage,
      this.skippingAmount = 1,
      required this.pagingDataCallback})
      : calculatedSkipping = skippingAmount;

  void incPageIndex() => calculatedSkipping += calculatedSkipping;

  void restPageIndex() => calculatedSkipping = skippingAmount;
}

enum PagingInsertionMode {
  addMode,
}
