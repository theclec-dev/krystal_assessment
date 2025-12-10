class AppConstants {
  // Database
  static const String dbName = 'tasks.db';
  static const int dbVersion = 1;

  // Table names
  static const String tasksTable = 'tasks';

  // App strings
  static const String appTitle = 'Personal Task Manager';
  static const String emptyTasksMessage =
      'No tasks yet. Create your first task!';
  static const String searchHint = 'Search tasks...';

  // Validation messages
  static const String titleRequiredError = 'Title is required';
  static const String titleTooShortError =
      'Title must be at least 3 characters';

  // Confirmation messages
  static const String deleteConfirmTitle = 'Delete Task';
  static const String deleteConfirmMessage =
      'Are you sure you want to delete this task?';
  static const String deleteConfirmButton = 'Delete';
  static const String cancelButton = 'Cancel';

  // Success messages
  static const String taskAddedSuccess = 'Task added successfully';
  static const String taskUpdatedSuccess = 'Task updated successfully';
  static const String taskDeletedSuccess = 'Task deleted successfully';
}
