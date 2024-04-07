// ignore_for_file: depend_on_referenced_packages

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

abstract class ViewModelAbstraction<ViewModel extends BaseViewModel> {
  final ViewModel viewModel;

  ViewModelAbstraction({required this.viewModel});
  @mustCallSuper
  showError(error) {
    if (error is DioException) {
      return switch (error.type) {
        DioExceptionType.cancel => BotToast.showText(text: error.message ?? ""),
        DioExceptionType.connectionError => BotToast.showText(text: ""),
        DioExceptionType.connectionTimeout => BotToast.showText(text: ""),
        _ => BotToast.showText(text: error.message ?? "")
      };
    }
    if (error is Map) {
      BotToast.showText(text: error.values.join(", "));
    }
  }
}
