

import 'package:simple_task_manager/application_layer/utils/rgeister_instance_util.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_viewmodel.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/data_sources/app_generic_list_data_src.dart';

final class AppGenericListLoadingDataDelegate<T> {
  final AppListViewModel viewModel;

  AppGenericListLoadingDataDelegate({
    required this.viewModel,
  });
  late List<T> data = lazyGetInstance(
      viewModel.dataSrc.persistentId, () => AppGenericListDataHolder<T>()).data;

  late int? totalAvailableDataCount = lazyGetInstance(
          viewModel.dataSrc.persistentId, () => AppGenericListDataHolder<T>())
      .totalDataCount;

  int get loadedDataCount => data.length;

  ///
  preparingData() {
    if (viewModel.dataSrc is AppGenericListLocalDataSrc<T>) {
      return data = List.of(
          (viewModel.dataSrc as AppGenericListLocalDataSrc<T>).initialData);
    }
    var apiDataSrc = viewModel.dataSrc as AppGenericListApiDataSrc<T>;

    ///No data or data is existed but no persistance
    if (data.isEmpty || (data.isNotEmpty && apiDataSrc.persistentId.isEmpty)) {
      ///
      _getApiDataAndSetItems(apiDataSrc);
    }
  }

  /// Fetches data from an API if the data source is configured to do so.

  Future _getApiDataAndSetItems(AppGenericListApiDataSrc<T> apiDataSrc) async {
    try {
      var apiItems = await viewModel.runBusyFuture(apiDataSrc.apiCallback(),
          throwException: true, busyObject: data);
      data = List.of(apiItems.$1);
      totalAvailableDataCount = apiItems.$2;
    } on Exception catch (e) {
      return viewModel.setError(e);
    }
  }

  void resetData() {
    data.clear();
    viewModel.pagingSettings?.restPageIndex();
    viewModel.rebuildUi();
  }
}

final class AppGenericListDataHolder<T> {
  List<T> data = <T>[];
  int? totalDataCount;
}
