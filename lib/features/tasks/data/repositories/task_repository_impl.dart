import 'package:krystal_assessment/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:krystal_assessment/features/tasks/data/models/task_model.dart';
import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';
import 'package:krystal_assessment/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      return await localDataSource.getAllTasks();
    } catch (e) {
      throw Exception('Failed to get all tasks: $e');
    }
  }

  @override
  Future<Task> getTaskById(String id) async {
    try {
      return await localDataSource.getTaskById(id);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.insertTask(taskModel);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.updateTask(taskModel);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllTasks();
      }
      return await localDataSource.searchTasks(query);
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }
}
