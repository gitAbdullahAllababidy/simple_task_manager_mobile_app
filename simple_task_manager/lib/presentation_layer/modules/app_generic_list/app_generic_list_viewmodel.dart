import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/data_sources/app_generic_list_data_src.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/delegates/app_generic_list_filter_procedure_delegate.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/delegates/app_generic_list_loading_data_delegate.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/delegates/paging_delegate.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/delegates/refresh_delegate.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/paging_data_object.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/refresh_indicator_data_object.dart';
import 'package:stacked/stacked.dart';

class AppListViewModel<T> extends BaseViewModel {
  final AppGenericListDataSrc dataSrc;
  final PagingSettings<T>? pagingSettings;
  final RefreshSetting<T>? refreshSetting;
  final void Function(List<T> data)? onDataLoadedCallback;

  ///Delegates
  late final AppGenericListPagingDelegate<T> appGenericListPagingDelegate =
      AppGenericListPagingDelegate<T>(viewModel: this);

  late final RefreshDelegate<T> refreshDelegate =
      RefreshDelegate(viewModel: this);

  late final AppGenericListLoadingDataDelegate<T>
      appGenericListLoadingDataDelegate =
      AppGenericListLoadingDataDelegate<T>(viewModel: this);

  late FilterProcedureDelegate<T> filterProcedureDelegate =
      FilterProcedureDelegate(this);

  ///
  late AutoScrollController autoScrollController = AutoScrollController()
    ..addListener(() {
      appGenericListPagingDelegate.handelPagination();
    });

  ///Run refreshing data from the dataSrc api or even custom refreshCallback.
  ///[runRefreshData] will reset all data, reset paging Index
  /// and load the first page data again

  Future? runRefreshData() => refreshDelegate.refreshKey.currentState?.show();
  Future? runRefreshDataWithoutLoader() => refreshDelegate.onRefresh();
  void resetWithoutRefreshingData() => appGenericListPagingDelegate.reset();

  void filteringData(
          String value, final bool Function(T item) filterCallback) =>
      filterProcedureDelegate.onFilter(value, filterCallback);

  List<T> get data => appGenericListLoadingDataDelegate.data;

  AppListViewModel({
    required this.dataSrc,
    required this.pagingSettings,
    required this.onDataLoadedCallback,
    required this.refreshSetting,
  });
}
