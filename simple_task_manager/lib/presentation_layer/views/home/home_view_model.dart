import 'package:simple_task_manager/presentation_layer/views/home/delegates/delete_task_delegate.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  late final DeleteTaskDelegate deleteTaskDelegate =
      DeleteTaskDelegate(viewModel: this);
}
