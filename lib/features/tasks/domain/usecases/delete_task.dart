import 'package:krystal_assessment/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTask(id);
  }
}
