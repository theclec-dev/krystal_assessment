# Personal Task Manager

A Flutter mobile application demonstrating clean architecture, state management best practices, and modern development patterns.

## 📋 Project Description

This is a task management application built as part of a technical assessment. The app allows users to create, read, update, and delete tasks with persistent local storage. It showcases understanding of state management, clean architecture, and mobile development best practices.

## ✨ Features

### Core Functionality

- ✅ **Task List Screen**: Display all tasks with title, description, and completion status
- ✅ **Add Task**: Create new tasks with title and description
- ✅ **Edit Task**: Modify existing task information
- ✅ **Delete Task**: Remove tasks with confirmation dialog
- ✅ **Toggle Completion**: Mark tasks as complete/incomplete
- ✅ **Search Tasks**: Filter tasks by title or description
- ✅ **Data Persistence**: Tasks are stored locally using SQLite
- ✅ **Empty State**: User-friendly message when no tasks exist
- ✅ **Error Handling**: Graceful error messages and retry functionality
- ✅ **Loading States**: Visual feedback during data operations
- ✅ **Splash Page**: A brief branded splash shown on app start
- ✅ **Theme Toggle**: App-level theme control with persistent choice (automatic/dark/light)

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **feature-first** folder structure.

### Architecture Layers

```
┌─────────────────────────────────────────────┐
│           Presentation Layer                │
│  (UI, Widgets, Pages, State Management)     │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│            Domain Layer                     │
│  (Entities, Use Cases, Repository           │
│   Interfaces - Business Logic)              │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│             Data Layer                      │
│  (Models, Data Sources, Repository          │
│   Implementations)                          │
└─────────────────────────────────────────────┘
```

### Folder Structure

```
lib/
├── application/              # Application-level configuration
│   ├── router/              # Auto Route navigation setup
│   │   ├── app_router.dart
│   │   └── app_router.gr.dart (generated)
│   └── theme/               # App theming
│       └── app_theme.dart
│       └── theme_notifier.dart
│
├── core/                    # Shared utilities and components
│   ├── components/          # Reusable UI components
│   │   ├── empty_state_widget.dart
│   │   ├── error_widget.dart
│   │   └── labeled_text_field.dart
│   │   └── loading_widget.dart
│   │   └── search_field.dart
│   ├── constants/           # App-wide constants
│   │   └── app_constants.dart
│   └── utils/              # Utility functions
│       └── date_formatter.dart
│
└── features/               # Feature modules
    └── tasks/              # Task management feature
        ├── data/           # Data layer
        │   ├── datasources/
        │   │   ├── local/
        │   │   │   └── database_helper.dart
        │   │   └── task_local_datasource.dart
        │   ├── models/
        │   │   └── task_model.dart
        │   └── repositories/
        │       └── task_repository_impl.dart
        │
        ├── domain/         # Domain layer
        │   ├── entities/
        │   │   └── task.dart
        │   ├── repositories/
        │   │   └── task_repository.dart
        │   └── usecases/
        │       ├── add_task.dart
        │       ├── delete_task.dart
        │       ├── get_all_tasks.dart
        │       ├── search_tasks.dart
        │       └── update_task.dart
        │
        └── presentation/   # Presentation layer
            ├── pages/
            │   ├── add_edit_task_page.dart
            │   └── task_list_page.dart
            ├── providers/
            │   └── task_providers.dart
            └── widgets/
                └── task_item.dart
```

## 🔧 Technology Stack

- **Framework**: Flutter 3.29.3
- **Language**: Dart 3.7.2+
- **State Management**: Riverpod 3.0.3
- **Local Database**: SQLite (sqflite 2.4.2)
- **Navigation**: Auto Route 10.1.0
- **Utilities**:
  - Equatable (for value equality)
  - UUID (for unique ID generation)

## 📐 Design Patterns & Best Practices

### 1. Clean Architecture

- **Separation of Concerns**: Each layer has distinct responsibilities
- **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)
- **Testability**: Business logic is isolated and easily testable
- **Maintainability**: Changes in one layer don't affect others

### 2. Repository Pattern

- Abstracts data source details from business logic
- Allows easy switching between local/remote data sources
- Interface defined in domain layer, implemented in data layer

### 3. Use Case Pattern

- Each use case represents a single business operation
- Encapsulates business rules and data flow
- Makes business logic explicit and reusable

### 4. State Management with Riverpod

- **Provider Architecture**: Dependency injection and state management
- **StateNotifier**: Manages task list state immutably
- **AsyncValue**: Handles loading, data, and error states elegantly
- **Reactive UI**: Automatically rebuilds when state changes

### 5. Code Quality

- **Naming Conventions**: Clear, descriptive names following Dart guidelines
- **Error Handling**: Try-catch blocks with meaningful error messages
- **Input Validation**: Form validation for required fields
- **User Feedback**: Loading indicators, error messages, success notifications

### 6. UI/UX Design

- **Material Design 3**: Modern, consistent UI
- **Responsive Layout**: Works on various screen sizes
- **Loading States**: Visual feedback during operations
- **Empty States**: Helpful messages when no data exists
- **Confirmation Dialogs**: Prevents accidental deletions
- **Search Functionality**: Real-time task filtering
- **Dynamic Themeing**: Allows dynamic theme switching

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart 3.7.2 or higher
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd krystal_assessment
```

2. Install dependencies:

```bash
flutter pub get
```

3. Generate routing files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```bash
flutter run
```

## 🧪 Testing

The architecture supports multiple testing levels:

### Unit Tests

Test individual use cases, repositories, and business logic:

```bash
flutter test test/unit
```

### Widget Tests

Test individual widgets and UI components:

```bash
flutter test test/widget
```

### Integration Tests

Test complete user flows:

```bash
flutter test test/integration
```

## 📱 Usage

### Creating a Task

1. Tap the floating action button (+)
2. Enter task title (minimum 3 characters)
3. Enter task description
4. Tap "Add Task" or the checkmark icon

### Editing a Task

1. Tap on any task in the list or tap the edit icon
2. Modify title or description
3. Tap "Update Task" or the checkmark icon

### Completing a Task

- Tap the checkbox next to the task title

### Deleting a Task

1. Tap the delete icon on any task
2. Confirm deletion in the dialog

### Searching Tasks

- Type in the search bar at the top
- Results filter in real-time
- Search matches both title and description

### Theme Control

- The app supports three theme modes: **Automatic (system)**, **Dark**, and **Light**.
- The theme button is available in the app bar on the main task list screen. It cycles the theme in the order: Automatic → Dark → Light → Automatic.
- The user's selection is persisted across app launches using local storage.

### Splash Page

- On app launch the splash page is shown first (configured as the initial route). After a brief animated intro the app navigates to the task list.

## 🎯 Assumptions & Decisions

### Assumptions Made

1. **Single User**: App designed for personal use (no authentication)
2. **Offline-First**: All data stored locally, no backend integration
3. **Simple Task Model**: Tasks have title, description, and completion status only
4. **No Task Priority**: All tasks treated equally (no high/medium/low priority)
5. **No Due Dates**: Tasks don't have deadlines or reminders
6. **No Categories/Tags**: Tasks aren't grouped or categorized

### Design Decisions

1. **Feature-First Architecture**: Easier to scale with multiple features
2. **Riverpod over Bloc**: Simpler syntax, better testability, less boilerplate
3. **SQLite over Hive**: More familiar SQL syntax, better for complex queries
4. **Auto Route**: Type-safe navigation with code generation
5. **Equatable**: Simplified value comparison for entities
6. **Material Design 3**: Modern, accessible UI components

### Challenges Addressed

1. **State Management**: Used Riverpod's AsyncValue for elegant loading/error states (Using Riverpod legacy package)
2. **Database Operations**: Wrapped in try-catch with meaningful error messages
3. **Search Performance**: Implemented database-level filtering for efficiency
4. **User Feedback**: Added loading indicators, snackbars, and confirmation dialogs
5. **Code Organization**: Clear separation of concerns following clean architecture

## 🔮 Future Enhancements

Potential improvements for production readiness:

- [ ] Add task categories/tags
- [ ] Implement task priorities
- [ ] Add due dates and reminders
- [ ] Support for task notes/attachments
- [ ] Implement task sorting options
- [ ] Implement task sharing
- [ ] Add data export/import
- [ ] Include analytics/statistics
- [ ] Add onboarding tutorial

## 📄 License

This project is created for assessment purposes.

## 👤 Author

Enemuoh, CHukwuebuka Charles

## 📞 Support

For questions or issues, please reach out via the provided contact information.

c.enemuoh97@gmail.com
07052158985, 08140907034

**Estimated Development Time**: ~8/9 hours (8:30pm - 11pm, 10th Dec; 3am - 9am)
**Completion Date**: December 2025
