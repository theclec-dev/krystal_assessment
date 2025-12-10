import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';
import 'package:krystal_assessment/features/tasks/domain/repositories/task_repository.dart';

class SearchTasks {
  final TaskRepository repository;

  SearchTasks(this.repository);

  Future<List<Task>> call(String query) async {
    return await repository.searchTasks(query);
  }
}
