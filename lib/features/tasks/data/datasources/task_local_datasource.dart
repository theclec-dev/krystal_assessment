import 'package:krystal_assessment/core/constants/app_constants.dart';
import 'package:krystal_assessment/features/tasks/data/datasources/local/database_helper.dart';
import 'package:krystal_assessment/features/tasks/data/models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel> getTaskById(String id);
  Future<void> insertTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> searchTasks(String query);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;

  TaskLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        AppConstants.tasksTable,
        orderBy: 'createdAt DESC',
      );
      return result.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        AppConstants.tasksTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isEmpty) {
        throw Exception('Task not found');
      }
      return TaskModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(AppConstants.tasksTable, task.toJson());
    } catch (e) {
      throw Exception('Failed to insert task: $e');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        AppConstants.tasksTable,
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        AppConstants.tasksTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        AppConstants.tasksTable,
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'createdAt DESC',
      );
      return result.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }
}
