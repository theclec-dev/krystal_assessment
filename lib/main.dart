import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krystal_assessment/application/router/app_router.dart';
import 'package:krystal_assessment/application/theme/app_theme.dart';
import 'package:krystal_assessment/application/theme/theme_notifier.dart';
import 'package:krystal_assessment/core/constants/app_constants.dart';

void main() {
  runApp(
    GestureDetector(
      child: ProviderScope(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
