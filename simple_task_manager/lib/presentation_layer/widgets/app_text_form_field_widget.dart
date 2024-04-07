import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';

class AppTextFormFieldWidget extends StatelessWidget {
  const AppTextFormFieldWidget(
      {super.key,
      this.textEditingController,
      this.validator,
      this.label,
      this.textInputType,
      this.formatters,
      this.onTap,
      this.withBorders = true,
      this.borderRadius = 12,
      this.icon,
      this.maxLines,
      this.floatingLabelBehavior});
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final String? label;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? formatters;
  final VoidCallback? onTap;
  final bool withBorders;
  final double borderRadius;
  final IconData? icon;
  final FloatingLabelBehavior? floatingLabelBehavior;
 final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onTap,
        child: TextFormField(
          enabled: onTap == null,
          controller: textEditingController,
          validator: validator,
          cursorRadius: const Radius.circular(10),
          cursorWidth: 1,
          keyboardType: textInputType,
          inputFormatters: formatters,
          maxLines: maxLines,
          decoration: withBorders
              ? InputDecoration(
                  prefixIcon: icon != null
                      ? Icon(
                          icon,
                          color: AppColors.brandPrimary,
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  labelText: label ?? "Label" "....",
                  labelStyle: appThem().textTheme.bodyMedium,
                  floatingLabelBehavior: floatingLabelBehavior,
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)),
                      borderSide: const BorderSide(
                          color: AppColors.brandSecondaryLight)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)),
                      borderSide: const BorderSide(color: AppColors.grayLight)))
              : InputDecoration(
                  prefixIcon: icon != null
                      ? Icon(
                          icon,
                          color: AppColors.brandPrimary,
                        )
                      : null,
                  labelText: label ?? "Label" "....",
                  floatingLabelBehavior: floatingLabelBehavior,
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.brandSecondaryLight)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.grayLight)),
                ),
        ),
      ),
    );
  }
}
