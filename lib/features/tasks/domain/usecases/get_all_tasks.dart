import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';
import 'package:krystal_assessment/features/tasks/domain/repositories/task_repository.dart';

class GetAllTasks {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getAllTasks();
  }
}
