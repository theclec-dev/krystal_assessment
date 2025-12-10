import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:krystal_assessment/features/tasks/data/datasources/local/database_helper.dart';
import 'package:krystal_assessment/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:krystal_assessment/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:krystal_assessment/features/tasks/domain/repositories/task_repository.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/add_task.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/delete_task.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/search_tasks.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/update_task.dart';
import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';

// Database Helper Provider
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// Data Source Provider
final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  final databaseHelper = ref.watch(databaseHelperProvider);
  return TaskLocalDataSourceImpl(databaseHelper: databaseHelper);
});

// Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource: localDataSource);
});

// Use Cases Providers
final getAllTasksProvider = Provider<GetAllTasks>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetAllTasks(repository);
});

final addTaskProvider = Provider<AddTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return AddTask(repository);
});

final updateTaskProvider = Provider<UpdateTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return UpdateTask(repository);
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return DeleteTask(repository);
});

final searchTasksProvider = Provider<SearchTasks>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return SearchTasks(repository);
});

// Task List State Provider
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>((ref) {
      final getAllTasks = ref.watch(getAllTasksProvider);
      final addTask = ref.watch(addTaskProvider);
      final updateTask = ref.watch(updateTaskProvider);
      final deleteTask = ref.watch(deleteTaskProvider);
      final searchTasks = ref.watch(searchTasksProvider);

      return TaskListNotifier(
        getAllTasks: getAllTasks,
        addTask: addTask,
        updateTask: updateTask,
        deleteTask: deleteTask,
        searchTasks: searchTasks,
      );
    });

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final GetAllTasks getAllTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final SearchTasks searchTasks;

  TaskListNotifier({
    required this.getAllTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.searchTasks,
  }) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await getAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addNewTask(Task task) async {
    try {
      await addTask(task);
      await loadTasks();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateExistingTask(Task task) async {
    try {
      await updateTask(task);
      await loadTasks();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteExistingTask(String id) async {
    try {
      await deleteTask(id);
      await loadTasks();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadTasks();
      return;
    }

    state = const AsyncValue.loading();
    try {
      final tasks = await searchTasks(query);
      state = AsyncValue.data(tasks);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );
    await updateExistingTask(updatedTask);
  }
}
