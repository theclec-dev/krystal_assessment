import 'package:flutter_test/flutter_test.dart';
import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';
import 'package:krystal_assessment/features/tasks/domain/repositories/task_repository.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/add_task.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/update_task.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/delete_task.dart';
import 'package:krystal_assessment/features/tasks/domain/usecases/search_tasks.dart';

class FakeTaskRepository implements TaskRepository {
  final List<Task> _store = [];

  @override
  Future<void> addTask(Task task) async {
    _store.add(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    _store.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    return List.unmodifiable(_store);
  }

  @override
  Future<Task> getTaskById(String id) async {
    return _store.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> updateTask(Task task) async {
    final idx = _store.indexWhere((t) => t.id == task.id);
    if (idx >= 0) _store[idx] = task;
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final q = query.toLowerCase();
    return _store
        .where(
          (t) =>
              t.title.toLowerCase().contains(q) ||
              t.description.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }
}

Task makeTask(String id, String title, String desc) => Task(
  id: id,
  title: title,
  description: desc,
  isCompleted: false,
  createdAt: DateTime.now(),
);

void main() {
  late FakeTaskRepository repo;
  late AddTask addTask;
  late GetAllTasks getAll;
  late UpdateTask updateTask;
  late DeleteTask deleteTask;
  late SearchTasks searchTasks;

  setUp(() {
    repo = FakeTaskRepository();
    addTask = AddTask(repo);
    getAll = GetAllTasks(repo);
    updateTask = UpdateTask(repo);
    deleteTask = DeleteTask(repo);
    searchTasks = SearchTasks(repo);
  });

  test('Add and GetAllTasks works', () async {
    final t1 = makeTask('1', 'First', 'First description');
    final t2 = makeTask('2', 'Second', 'Second description');

    await addTask.call(t1);
    await addTask.call(t2);

    final all = await getAll.call();
    expect(all.length, 2);
    expect(all, containsAll([t1, t2]));
  });

  test('UpdateTask updates existing task', () async {
    final t = makeTask('u1', 'Title', 'Desc');
    await addTask.call(t);

    final updated = t.copyWith(title: 'New Title');
    await updateTask.call(updated);

    final all = await getAll.call();
    expect(all.first.title, 'New Title');
  });

  test('DeleteTask removes task', () async {
    final t = makeTask('d1', 'ToDelete', 'x');
    await addTask.call(t);
    await deleteTask.call('d1');

    final all = await getAll.call();
    expect(all.where((x) => x.id == 'd1'), isEmpty);
  });

  test('SearchTasks returns matching tasks', () async {
    await addTask.call(makeTask('s1', 'Shopping', 'Buy milk'));
    await addTask.call(makeTask('s2', 'Work', 'Email boss'));

    final res = await searchTasks.call('shop');
    expect(res.length, 1);
    expect(res.first.title, 'Shopping');
  });
}
