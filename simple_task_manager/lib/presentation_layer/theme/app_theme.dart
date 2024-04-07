import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';

ThemeData appThem() => ThemeData(
    primaryColor: AppColors.brandPrimary,
    drawerTheme: const DrawerThemeData(),
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
      return switch (states) {
        _ when states.contains(MaterialState.selected) =>
          AppColors.brandPrimary,
        _ => null,
      };
    }), trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
      return switch (states) {
        _ when states.contains(MaterialState.selected) =>
          AppColors.brandPrimary.withOpacity(.3),
        _ => null,
      };
    })),
    datePickerTheme: const DatePickerThemeData(
        headerBackgroundColor: AppColors.brandPrimary),
    appBarTheme: const AppBarTheme(color: AppColors.white),
    tabBarTheme: const TabBarTheme(
        overlayColor: MaterialStatePropertyAll(AppColors.grayDark),
        labelColor: AppColors.brandPrimary,
        dividerColor: AppColors.textSecondary,
        indicatorColor: AppColors.brandPrimary),
    inputDecorationTheme:
        const InputDecorationTheme(border: OutlineInputBorder()),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: AppColors.textSecondary),
    textTheme: TextTheme(
      titleLarge:
          GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.poppins(fontSize: 20),
      titleSmall: GoogleFonts.poppins(fontSize: 16),
      bodyLarge: GoogleFonts.poppins(fontSize: 16),
      bodyMedium: GoogleFonts.poppins(fontSize: 14),
      bodySmall: GoogleFonts.poppins(fontSize: 12),
      labelLarge: GoogleFonts.poppins(fontSize: 12),
      labelMedium: GoogleFonts.poppins(fontSize: 10),
      labelSmall: GoogleFonts.poppins(fontSize: 8),
    ));
