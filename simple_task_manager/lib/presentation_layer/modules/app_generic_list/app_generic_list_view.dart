import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_viewmodel.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/data_sources/app_generic_list_data_src.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/data_count_settings.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/paging_data_object.dart';
import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/settings/refresh_indicator_data_object.dart';
import 'package:stacked/stacked.dart';

/// A generic list view widget that supports pagination, refresh, and custom item rendering.
/// This widget is built using the `flutter_hooks` package for managing state and the `stacked` package for MVVM architecture.
class AppGenericListView<T> extends HookWidget {
  ///Bottom seperator value between list items
  final double? seperatorValue;

  ///Defining data src wether if from api or local data
  final AppGenericListDataSrc dataSrc;

  /// `onCreated`: A callback function that is executed when the list's view model is initialized.
  /// This is the ideal place to perform additional setup on the view model, such as data fetching or state initialization.
  final void Function(AppListViewModel<T> appGenericListViewModel) onCreated;

  /// `builder`: A builder function for creating the widget representation of each item in `data`.
  /// It provides the current build context, the data item, and its index within the list.
  /// If `null`, a default Text widget displaying 'data' is used.
  final Widget Function(BuildContext context, T data, int index)? builder;

  /// `refreshSetting`: Configuration for the pull-to-refresh feature. It allows customizing the refresh indicator's appearance and behavior.
  /// If `null`, the list will not be refreshable.
  final RefreshSetting<T>? refreshSetting;

  /// `addAutomaticKeepAlives`: Determines whether to wrap each child in an `AutomaticKeepAlive` widget.
  /// This is useful for retaining state in list items when they scroll off and back on screen.
  final bool addAutomaticKeepAlives;

  /// `addRepaintBoundaries`: Determines whether to wrap each child in a `RepaintBoundary` widget.
  /// This can improve scrolling performance by isolating the repaints to the individual items.
  final bool addRepaintBoundaries;

  /// `autoScrollhighLightColor`: The highlight color for the `AutoScrollTag`. This color is displayed when an item is programmatically scrolled into view.
  /// If `null`, no highlight color is applied.
  final Color? autoScrollhighLightColor;

  /// `paginationSettings`: Configuration for pagination behavior, such as lazy loading items when scrolling to the end of the list.
  /// If `null`, pagination is disabled.
  final PagingSettings<T>? paginationSettings;

  /// `padding`: The padding around the list view. This affects how items are spaced within the list.
  final EdgeInsets padding;

  /// `margin`: The padding around the list view. This affects how items are spaced within the list.
  final EdgeInsetsGeometry margin;

  /// `reversed`: Whether the list view is reversed. When `true`, the list starts at the bottom and scrolls upwards.
  final bool reversed;

  /// When the callback is provided and not null, it serves as the action
  /// triggered by a default button, typically used to retry or navigate to
  /// relevant sections. If the callback is null, the default button is not
  /// displayed in the empty state UI.
  final void Function()? defaultEmptyOrErrorStateCallback;

  /// `emptyErrorWidgetCallback`: A widget displayed when `data` is empty and exception somewhere erased, providing feedback to the user that no items are available.
  final Widget Function(AppListViewModel<T> viewModel)?
      emptyErrorWidgetCallback;

  /// `emptyNoDataWidgetCallback`: A widget displayed when `data` is empty, providing feedback to the user that no items are available.
  final Widget Function(AppListViewModel<T> viewModel)?
      emptyNoDataWidgetCallback;

  final DataCountInfoSettings dataCountInfoSettings;

  /// `onDataLoadedCallback`: When the data is loaded this callback fired and passing the loaded data.
  final void Function(List<T> data)? onDataLoadedCallback;

  final bool shrinkWrap;

  /// Example usage of `AppGenericListView` with `ClinicEntity`:
  /// {@tool dartpad}
  /// ```dart
  /// AppGenericListView<ClinicEntity>(
  ///   onCreated: (appGenericListViewModel) {
  ///     // Here you can interact with the appGenericListViewModel directly,
  ///     // such as adding or removing items, or invoking a UI rebuild:
  ///      appGenericListViewModel.data.add(value);
  ///      appGenericListViewModel.data.remove(value);
  ///      appGenericListViewModel.rebuildUi();
  ///   },
  ///        dataSrc: AppGenericListApiDataSrc<ClinicEntity>(
  ///     apiCallback: () async {
  ///   var data =
  ///       await (sl<ClinicsRepository>()).getClinics(
  ///     GetClinicsParams(),
  ///   );
  ///   return data.fold((l) => (<ClinicEntity>[], 0),
  /// // Total count here must be fetched from api, so you need to pass items list and its fetched total count
  ///       (r) => (r.items, r.totalCount));
  /// }),
  ///   paginationSettings: PagingSettings(
  ///     pagingDataCallback: (pageSize, pageIndex) async {
  ///       // Simulate a network call to fetch paginated data
  ///       return await Future.delayed(
  ///         const Duration(seconds: 2),
  ///         () => [
  ///           ...controller.clinics?.items ?? [],
  ///         ],
  ///       );
  ///     },
  ///   ),
  ///  dataCountWidgetCallback:
  ///     (totalAvailableDataCount, loadedDataCount) => Row(
  ///   mainAxisAlignment: MainAxisAlignment.end,
  ///   children: [
  ///     Container(
  ///       child: Text(
  ///           "$loadedDataCount/$totalAvailableDataCount"),
  ///     ),
  ///   ],
  /// ),
  ///   refreshSetting: RefreshSetting(
  ///     refreshDataCallback: () async {
  ///       // Simulate a network call to refresh the entire list
  ///       return await Future.delayed(
  ///         const Duration(seconds: 2),
  ///         () => [
  ///           ...controller.clinics?.items ?? [],
  ///         ],
  ///       );
  ///     },
  ///   ),
  ///   key: ValueKey("ClinicsView/itemsList"),
  ///   data: controller.clinics?.items ?? [],
  ///   padding: EdgeInsets.symmetric(
  ///     vertical: 8.hx,
  ///     horizontal: 8.wx,
  ///   ),
  ///   emptyWidget: EmptyWidget(
  ///     topMargin: 110.hx,
  ///     entity: "No Clinics",
  ///     imageAssetPath: "assets/emptyClinics.png",
  ///   ),
  ///   builder: (ctx, item, index) {
  ///     // Custom list item builder function
  ///     return _clinicListItemBuilder(item, controller, index, context);
  ///   },
  /// ),
  /// ```
  /// {@end-tool}
  /// ```

  const AppGenericListView(
      {super.key,
      required this.onCreated,
      required this.dataSrc,
      this.builder,
      this.seperatorValue,
      this.defaultEmptyOrErrorStateCallback,
      this.refreshSetting,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.autoScrollhighLightColor,
      this.paginationSettings,
      this.padding = const EdgeInsets.symmetric(horizontal: 20),
      this.margin = const EdgeInsets.only(),
      this.reversed = false,
      this.dataCountInfoSettings = const DataCountInfoSettings(),
      this.emptyErrorWidgetCallback,
      this.emptyNoDataWidgetCallback,
      this.shrinkWrap = false,
      this.onDataLoadedCallback});

  @override
  Widget build(BuildContext context) {
    final calculatedSeparatorValues = MediaQuery.sizeOf(context).height / 40;
    return ViewModelBuilder<AppListViewModel<T>>.reactive(
        onDispose: (viewModel) {
          viewModel.filterProcedureDelegate.resetOnDispose();
        },
        onViewModelReady: (viewModel) {
          viewModel.appGenericListLoadingDataDelegate.preparingData();
          onCreated.call(viewModel);
        },
        viewModelBuilder: () => AppListViewModel<T>(
            dataSrc: dataSrc,
            pagingSettings: paginationSettings,
            refreshSetting: refreshSetting,
            onDataLoadedCallback: onDataLoadedCallback),
        builder: (context, viewModel, _) {
          return Scrollbar(
            interactive: true,
            controller: viewModel.autoScrollController,
            radius: const Radius.circular(10),
            child: RefreshIndicator.adaptive(
              key: viewModel.refreshDelegate.refreshKey,
              backgroundColor: refreshSetting?.backgroundColor,
              color: refreshSetting?.color ?? Theme.of(context).primaryColor,
              displacement: refreshSetting?.displacement ?? 40.0,
              edgeOffset: refreshSetting?.edgeOffset ?? 0.0,
              notificationPredicate: refreshSetting?.notificationPredicate ??
                  defaultScrollNotificationPredicate,
              semanticsLabel: refreshSetting?.semanticsLabel,
              semanticsValue: refreshSetting?.semanticsValue,
              strokeWidth: refreshSetting?.strokeWidth ??
                  RefreshProgressIndicator.defaultStrokeWidth,
              triggerMode: refreshSetting?.triggerMode ??
                  RefreshIndicatorTriggerMode.anywhere,
              onRefresh: viewModel.refreshDelegate.onRefresh,
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  margin: margin,
                  child: Stack(
                    children: [
                      ///Empty no data state
                      if (viewModel
                              .appGenericListLoadingDataDelegate.data.isEmpty &&
                          !viewModel.anyObjectsBusy)
                        SizedBox(
                            height: constraints.maxHeight,
                            child: _buildEmptyNoDataWidget(context, viewModel)),

                      ///Error no data state
                      if (viewModel
                              .appGenericListLoadingDataDelegate.data.isEmpty &&
                          viewModel.hasError &&
                          !viewModel.anyObjectsBusy)
                        SizedBox(
                            height: constraints.maxHeight,
                            child: _buildEmptyErrorWidget(context, viewModel)),

                      ///Busy state (Loading data ....)
                      if (viewModel.busy(
                          viewModel.appGenericListLoadingDataDelegate.data))
                        _buildLoadingWidget(),

                      ///Data loaded state
                      if (viewModel.data.isNotEmpty)
                        _buildDataWidget(viewModel,
                            calculatedSeparatorValues:
                                calculatedSeparatorValues),

                      ///Show loading more loader in case of request new page data
                      if (viewModel.busy(viewModel.pagingSettings))
                        _buildLoadingMoreWidget(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Builds the widget that displays the list of items.
  /// Displays an empty widget if the list is empty.
  Widget _buildDataWidget(AppListViewModel<T> viewModel,
      {required double calculatedSeparatorValues}) {
    return Column(
      children: [
        Expanded(
          child: ListView.custom(
            controller: viewModel.autoScrollController,
            padding: padding.copyWith(top: 14),
            reverse: reversed,
            shrinkWrap: shrinkWrap,
            physics: const AlwaysScrollableScrollPhysics(),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => AutoScrollTag(
                key: ValueKey(index),
                index: index,
                highlightColor: autoScrollhighLightColor,
                controller: viewModel.autoScrollController,
                child: Container(
                  margin: EdgeInsets.only(bottom: calculatedSeparatorValues),
                  child: builder?.call(
                          context,
                          viewModel
                              .appGenericListLoadingDataDelegate.data[index],
                          index) ??
                      const Text("Data"),
                ),
              ),
              childCount:
                  viewModel.appGenericListLoadingDataDelegate.data.length,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
            ),
          ),
        ),
        if (dataCountInfoSettings.show)
          dataCountInfoSettings.dataCountWidgetCallback?.call(
                  viewModel.appGenericListLoadingDataDelegate
                      .totalAvailableDataCount,
                  viewModel
                      .appGenericListLoadingDataDelegate.loadedDataCount) ??
              DataCountInfoSettings.dataCountDefaultWidgetBuilder(
                  loadedDataCount: viewModel
                      .appGenericListLoadingDataDelegate.loadedDataCount,
                  totalAvailableDataCount: viewModel
                      .appGenericListLoadingDataDelegate
                      .totalAvailableDataCount),
      ],
    );
  }

  Widget _buildEmptyNoDataWidget(
      BuildContext context, AppListViewModel<T> viewModel) {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: emptyNoDataWidgetCallback?.call(viewModel) ??
            _emptyWidgetBuilder(context, viewModel));
  }

  Widget _buildEmptyErrorWidget(
      BuildContext context, AppListViewModel<T> viewModel) {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: emptyErrorWidgetCallback?.call(viewModel) ??
            _emptyWidgetBuilder(context, viewModel));
  }

  /// Builds the widget displayed at the bottom of the list when more items are being loaded.
  Align _buildLoadingMoreWidget() {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: paginationSettings?.pagingLoadingMoreWidget ??
          const LinearProgressIndicator(minHeight: 2),
    );
  }

  /// Builds loading widget
  Widget _buildLoadingWidget() {
    var apiDataSrc = dataSrc as AppGenericListApiDataSrc<T>;
    return Align(
      alignment: AlignmentDirectional.center,
      child: apiDataSrc.loadingWidget,
    );
  }

  Widget _emptyWidgetBuilder(
      BuildContext context, AppListViewModel<dynamic> viewModel) {
    return NoDataWidget(
      onRetry: () {
        viewModel.runRefreshData();
      },
    );
  }
}

class NoDataWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NoDataWidget({
    Key? key,
    this.message = 'No data available',
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
