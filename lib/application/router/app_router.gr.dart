// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddEditTaskPage]
class AddEditTaskRoute extends PageRouteInfo<AddEditTaskRouteArgs> {
  AddEditTaskRoute({Key? key, Task? task, List<PageRouteInfo>? children})
    : super(
        AddEditTaskRoute.name,
        args: AddEditTaskRouteArgs(key: key, task: task),
        initialChildren: children,
      );

  static const String name = 'AddEditTaskRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddEditTaskRouteArgs>(
        orElse: () => const AddEditTaskRouteArgs(),
      );
      return AddEditTaskPage(key: args.key, task: args.task);
    },
  );
}

class AddEditTaskRouteArgs {
  const AddEditTaskRouteArgs({this.key, this.task});

  final Key? key;

  final Task? task;

  @override
  String toString() {
    return 'AddEditTaskRouteArgs{key: $key, task: $task}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddEditTaskRouteArgs) return false;
    return key == other.key && task == other.task;
  }

  @override
  int get hashCode => key.hashCode ^ task.hashCode;
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TaskListPage]
class TaskListRoute extends PageRouteInfo<void> {
  const TaskListRoute({List<PageRouteInfo>? children})
    : super(TaskListRoute.name, initialChildren: children);

  static const String name = 'TaskListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TaskListPage();
    },
  );
}
