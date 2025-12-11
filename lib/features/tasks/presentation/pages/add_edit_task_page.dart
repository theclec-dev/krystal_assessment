import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krystal_assessment/core/constants/app_constants.dart';
import 'package:krystal_assessment/features/tasks/domain/entities/task.dart';
import 'package:krystal_assessment/features/tasks/presentation/providers/task_providers.dart';
import 'package:uuid/uuid.dart';
import 'package:krystal_assessment/core/components/labeled_text_field.dart';

@RoutePage()
class AddEditTaskPage extends ConsumerStatefulWidget {
  final Task? task;

  const AddEditTaskPage({super.key, this.task});

  @override
  ConsumerState<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends ConsumerState<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.task != null;

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final task = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        updatedAt: isEditing ? DateTime.now() : null,
      );

      if (isEditing) {
        await ref.read(taskListProvider.notifier).updateExistingTask(task);
      } else {
        await ref.read(taskListProvider.notifier).addNewTask(task);
      }

      if (mounted) {
        context.router.maybePop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? AppConstants.taskUpdatedSuccess
                  : AppConstants.taskAddedSuccess,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              onPressed: _saveTask,
              icon: const Icon(Icons.check),
              tooltip: 'Save',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LabeledTextField(
              controller: _titleController,
              labelText: 'Title',
              hintText: 'Enter task title',
              prefixIcon: Icons.title,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppConstants.titleRequiredError;
                }
                if (value.trim().length < 3) {
                  return AppConstants.titleTooShortError;
                }
                return null;
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              controller: _descriptionController,
              labelText: 'Description',
              hintText: 'Enter task description',
              prefixIcon: Icons.description,
              alignLabelWithHint: true,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveTask,
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.save),
                label: Text(isEditing ? 'Update Task' : 'Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
