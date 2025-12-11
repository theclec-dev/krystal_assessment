import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krystal_assessment/application/router/app_router.dart';
import 'package:krystal_assessment/application/theme/theme_notifier.dart';
import 'package:krystal_assessment/core/components/search_field.dart';
import 'package:krystal_assessment/core/components/empty_state_widget.dart';
import 'package:krystal_assessment/core/components/error_widget.dart';
import 'package:krystal_assessment/core/components/loading_widget.dart';
import 'package:krystal_assessment/core/constants/app_constants.dart';
import 'package:krystal_assessment/features/tasks/presentation/providers/task_providers.dart';
import 'package:krystal_assessment/features/tasks/presentation/widgets/task_item.dart';

@RoutePage()
class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    ref.read(taskListProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final taskListState = ref.watch(taskListProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    IconData themeIcon;
    if (themeMode == ThemeMode.system) {
      themeIcon = Icons.nights_stay;
    } else if (themeMode == ThemeMode.dark) {
      themeIcon = Icons.wb_sunny;
    } else {
      themeIcon = Icons.brightness_auto;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(themeIcon),
            onPressed:
                () => ref.read(themeNotifierProvider.notifier).toggleNext(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              controller: _searchController,
              hintText: AppConstants.searchHint,
              showClear: _searchController.text.isNotEmpty,
              onClear: () {
                _searchController.clear();
                _onSearchChanged('');
              },
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: taskListState.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return EmptyStateWidget(
              message:
                  ref.watch(searchQueryProvider).isEmpty
                      ? AppConstants.emptyTasksMessage
                      : 'No tasks found matching your search.',
              actionText:
                  ref.watch(searchQueryProvider).isEmpty ? 'Add Task' : null,
              onAction:
                  ref.watch(searchQueryProvider).isEmpty
                      ? () => context.router.push(AddEditTaskRoute())
                      : null,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(
                task: task,
                onTap: () => context.router.push(AddEditTaskRoute(task: task)),
                onToggle:
                    () => ref
                        .read(taskListProvider.notifier)
                        .toggleTaskCompletion(task),
                onDelete: () => _showDeleteConfirmation(task.id),
              );
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Loading tasks...'),
        error:
            (error, _) => ErrorDisplayWidget(
              message: error.toString(),
              onRetry: () => ref.read(taskListProvider.notifier).loadTasks(),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.push(AddEditTaskRoute()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(String taskId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(AppConstants.deleteConfirmTitle),
            content: const Text(AppConstants.deleteConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(AppConstants.cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text(AppConstants.deleteConfirmButton),
              ),
            ],
          ),
    );

    if (confirmed == true && mounted) {
      await ref.read(taskListProvider.notifier).deleteExistingTask(taskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.taskDeletedSuccess),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
