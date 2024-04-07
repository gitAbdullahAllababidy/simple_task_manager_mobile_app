


import 'package:simple_task_manager/presentation_layer/modules/app_generic_list/app_generic_list_viewmodel.dart';

class FilterProcedureDelegate<T> {
  final AppListViewModel<T> viewModel;

  var originalItems = <T>[];

  FilterProcedureDelegate(this.viewModel)
      : originalItems = List.of(viewModel.data);


  onFilter(String val, bool Function(T item) filterCallback) {
    if (val.isEmpty) {
      viewModel.appGenericListLoadingDataDelegate.data = List.of(originalItems);
    } else {
      viewModel.appGenericListLoadingDataDelegate.data = List.of(
          originalItems.where((element) => filterCallback(element)));
    }
    viewModel.rebuildUi();
  }

  ///Restore the original data set after closing the view
  resetOnDispose() {
    viewModel.appGenericListLoadingDataDelegate.data = List.of(originalItems);
  }
}
