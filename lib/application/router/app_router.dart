import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';
import 'package:krystal_assessment/features/tasks/presentation/pages/add_edit_task_page.dart';
import 'package:krystal_assessment/features/tasks/presentation/pages/task_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: TaskListRoute.page, initial: true),
    AutoRoute(page: AddEditTaskRoute.page),
  ];
}
