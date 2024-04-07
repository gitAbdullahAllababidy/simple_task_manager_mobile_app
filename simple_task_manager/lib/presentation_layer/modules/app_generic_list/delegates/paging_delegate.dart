import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_viewmodel.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/paging_data_object.dart';

final class AppGenericListPagingDelegate<T> {
  final AppListViewModel<T> viewModel;

  void Function()? noMoreDataCallback;

  AppGenericListPagingDelegate({
    required this.viewModel,
  });

  AutoScrollController get autoScrollController =>
      viewModel.autoScrollController;

  PagingSettings<T>? get pagingSettings => viewModel.pagingSettings;

  bool _hasNextPage = true;

  bool get getItHasNextPage => _hasNextPage;

  set setItHasNextPage(bool value) {
    _hasNextPage = value;
  }

  void handelPagination() async {
    ///Paging not activated
    ///(where the PagingSettings must be set at the initializing of AppGenericList to
    ///activate paging feature)
    try {
      if (pagingSettings?.pagingDataCallback == null) {
        return;
      }
      ///Stop loading data in case of all item has been loaded
      if (viewModel.appGenericListLoadingDataDelegate.totalAvailableDataCount ==
          viewModel.appGenericListLoadingDataDelegate.data.length) {
        return;
      }

      if (autoScrollController.position.maxScrollExtent ==
              autoScrollController.position.pixels &&
          getItHasNextPage) {
        var newData = await viewModel.runBusyFuture<List<T>>(
            pagingSettings!.pagingDataCallback(
                pagingSettings!.skippingAmount, pagingSettings!.calculatedSkipping),
            busyObject: pagingSettings);

        ///
        pagingSettings?.incPageIndex();

        ///
        setItHasNextPage = !(newData.length < pagingSettings!.skippingAmount);

        switch (pagingSettings!.pagingInsertionMode) {
          case PagingInsertionMode.addMode:
            viewModel.appGenericListLoadingDataDelegate.data.addAll(newData);
            viewModel.rebuildUi();
            break;
        }

        if (newData.isNotEmpty) {
          autoScrollController.animateTo(
              autoScrollController.offset +
                  pagingSettings!.animationOffsetValueAfterLoadingNewData,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        }
        if (newData.isEmpty) {
          noMoreDataCallback?.call();
          if (pagingSettings?.noMoreDataMessage is String) {
            BotToast.showText(
                text: pagingSettings?.noMoreDataMessage ?? "No more data !");
          }
        }
      }
    } on Exception catch (e) {
      viewModel.setError(e);
    }
  }

  void reset() {
    pagingSettings?.restPageIndex();
    setItHasNextPage = true;
  }
}
