import 'package:flutter/material.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget(
      {super.key, this.voidCallback, this.label, this.outlinedStyle = false});
  final VoidCallback? voidCallback;
  final String? label;
  final bool outlinedStyle;
  @override
  Widget build(BuildContext context) {
    return outlinedStyle
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
                side:
                    const BorderSide(color: AppColors.brandPrimary, width: .3)),
            onPressed: voidCallback?.call,
            child: Text(
              label ?? "Confirm",
              style: appThem()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.brandPrimary),
            ),
          )
        : ElevatedButton(
            onPressed: () {
              voidCallback?.call();
            },
            
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              
            ),
            child: Text(
              label ?? "Confirm",
              style: appThem()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.white),
            ),
          );
  }
}
