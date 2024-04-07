import 'package:flutter/material.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_viewmodel.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/data_sources/app_generic_list_data_src.dart';


final class RefreshDelegate<T> {
  final AppListViewModel<T> viewModel;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  RefreshDelegate({required this.viewModel});

  Future onRefresh() async {
    try {
      late Future<(List<T>, int?)> refreshCallback;
      if (viewModel.refreshSetting?.refreshDataCallback == null &&
          viewModel.dataSrc is AppGenericListApiDataSrc<T>) {
        refreshCallback =
            (viewModel.dataSrc as AppGenericListApiDataSrc<T>).apiCallback();
      } else {
        refreshCallback = viewModel.refreshSetting!.refreshDataCallback();
      }

      (List<T>, int?) newData = await viewModel.runBusyFuture(refreshCallback);

      viewModel.appGenericListPagingDelegate.reset();
      viewModel.appGenericListLoadingDataDelegate.data = newData.$1;
      viewModel.onDataLoadedCallback?.call(newData.$1);
      viewModel.appGenericListLoadingDataDelegate.totalAvailableDataCount =
          newData.$2;
      viewModel.rebuildUi();
    } on Exception catch (e) {
      viewModel.setError(e);
    }
  }
}
