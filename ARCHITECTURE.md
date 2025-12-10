# Architecture Documentation

## Clean Architecture Overview

This project implements Clean Architecture with a feature-first approach, organizing code by features rather than by technical layers.

## Layer Dependencies

```
┌──────────────────────────────────────────────────────────┐
│                    main.dart                             │
│              (Application Entry Point)                   │
└─────────────────────┬────────────────────────────────────┘
                      │
┌─────────────────────▼────────────────────────────────────┐
│               APPLICATION LAYER                          │
│  ┌────────────────┐         ┌────────────────┐          │
│  │  Router Setup  │         │  Theme Config  │          │
│  │  (Auto Route)  │         │  (Material 3)  │          │
│  └────────────────┘         └────────────────┘          │
└──────────────────────────────────────────────────────────┘
                      │
┌─────────────────────▼────────────────────────────────────┐
│               PRESENTATION LAYER                         │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Pages (UI Screens)                                │  │
│  │  • TaskListPage                                    │  │
│  │  • AddEditTaskPage                                 │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Providers (State Management - Riverpod)           │  │
│  │  • TaskListNotifier (manages task state)           │  │
│  │  • Dependency injection providers                  │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Widgets (Reusable UI Components)                  │  │
│  │  • TaskItem                                        │  │
│  │  • EmptyStateWidget                                │  │
│  │  • LoadingWidget                                   │  │
│  │  • ErrorDisplayWidget                              │  │
│  └────────────────────────────────────────────────────┘  │
└─────────────────────┬────────────────────────────────────┘
                      │ Uses
┌─────────────────────▼────────────────────────────────────┐
│                  DOMAIN LAYER                            │
│        (Pure Business Logic - No Dependencies)           │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Entities (Business Objects)                       │  │
│  │  • Task (id, title, description, isCompleted, etc) │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Repository Interfaces (Contracts)                 │  │
│  │  • TaskRepository                                  │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Use Cases (Business Operations)                   │  │
│  │  • GetAllTasks                                     │  │
│  │  • AddTask                                         │  │
│  │  • UpdateTask                                      │  │
│  │  • DeleteTask                                      │  │
│  │  • SearchTasks                                     │  │
│  └────────────────────────────────────────────────────┘  │
└─────────────────────▲────────────────────────────────────┘
                      │ Implements
┌─────────────────────┴────────────────────────────────────┐
│                   DATA LAYER                             │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Models (Data Transfer Objects)                    │  │
│  │  • TaskModel (converts Task ↔ Database)           │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Data Sources                                      │  │
│  │  • TaskLocalDataSource (SQLite operations)         │  │
│  │  • DatabaseHelper (DB initialization)              │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Repository Implementations                        │  │
│  │  • TaskRepositoryImpl                              │  │
│  └────────────────────────────────────────────────────┘  │
└─────────────────────┬────────────────────────────────────┘
                      │
┌─────────────────────▼────────────────────────────────────┐
│              EXTERNAL DEPENDENCIES                       │
│  • SQLite Database (sqflite)                            │
│  • File System                                          │
└──────────────────────────────────────────────────────────┘
```

## Data Flow

### Reading Tasks (Get All Tasks)

```
User Action (View Tasks)
        ↓
TaskListPage (Presentation)
        ↓
TaskListNotifier (State Management)
        ↓
GetAllTasks UseCase (Domain)
        ↓
TaskRepository Interface (Domain)
        ↓
TaskRepositoryImpl (Data)
        ↓
TaskLocalDataSource (Data)
        ↓
DatabaseHelper (Data)
        ↓
SQLite Database
        ↓
Returns: List<TaskModel>
        ↓
Converts to: List<Task> (Entity)
        ↓
Updates State: AsyncValue<List<Task>>
        ↓
UI Rebuilds with Data
```

### Creating a Task (Add Task)

```
User Input (Add Task Form)
        ↓
AddEditTaskPage (Presentation)
        ↓
Form Validation
        ↓
Creates Task Entity
        ↓
TaskListNotifier.addNewTask()
        ↓
AddTask UseCase (Domain)
        ↓
TaskRepository.addTask()
        ↓
TaskRepositoryImpl (Data)
        ↓
Converts Task → TaskModel
        ↓
TaskLocalDataSource.insertTask()
        ↓
SQLite INSERT operation
        ↓
Success/Error handling
        ↓
Reload tasks
        ↓
UI updates with new task
```

## State Management Flow (Riverpod)

```
┌────────────────────────────────────────────────────┐
│              Provider Hierarchy                    │
└────────────────────────────────────────────────────┘

databaseHelperProvider (Singleton)
        ↓
taskLocalDataSourceProvider
        ↓
taskRepositoryProvider
        ↓
┌───────────────┬──────────────┬─────────────┬────────────┐
↓               ↓              ↓             ↓            ↓
getAllTasks   addTask    updateTask   deleteTask   searchTasks
Provider      Provider    Provider     Provider     Provider
        ↓               ↓              ↓             ↓            ↓
        └───────────────┴──────────────┴─────────────┴────────────┘
                                ↓
                    taskListProvider (StateNotifier)
                                ↓
                    AsyncValue<List<Task>>
                    • loading
                    • data(tasks)
                    • error(exception)
                                ↓
                         UI Components
                         • TaskListPage
                         • TaskItem
```

## Key Design Patterns

### 1. Repository Pattern

- **Interface**: Defined in Domain layer (`TaskRepository`)
- **Implementation**: In Data layer (`TaskRepositoryImpl`)
- **Benefit**: Decouples business logic from data sources

### 2. Use Case Pattern

- Each business operation is a separate class
- Single Responsibility Principle
- Easy to test and maintain
- Clear business intent

### 3. Dependency Injection (Riverpod)

- All dependencies injected via providers
- No tight coupling between layers
- Easy to mock for testing
- Automatic cleanup

### 4. State Management (Riverpod)

- Immutable state
- Reactive UI updates
- Elegant error handling
- Loading states

### 5. Model-Entity Separation

- **Entity**: Business object (Domain layer)
- **Model**: Data transfer object (Data layer)
- Models know how to convert to/from database
- Entities are pure business logic

## Benefits of This Architecture

1. **Testability**

   - Each layer can be tested independently
   - Easy to mock dependencies
   - Business logic isolated from UI and data

2. **Maintainability**

   - Clear separation of concerns
   - Changes in one layer don't affect others
   - Easy to locate and fix bugs

3. **Scalability**

   - Easy to add new features
   - Can switch data sources without changing business logic
   - Can change UI without affecting domain

4. **Flexibility**

   - Can easily add new data sources (API, cache, etc.)
   - Can swap state management solutions
   - Can change UI framework

5. **Team Collaboration**
   - Different developers can work on different layers
   - Clear contracts between layers
   - Less merge conflicts

## SOLID Principles Applied

### Single Responsibility Principle (SRP)

- Each use case has one responsibility
- Each repository handles one entity type
- Each widget has one purpose

### Open/Closed Principle (OCP)

- Open for extension (can add new use cases)
- Closed for modification (existing code unchanged)

### Liskov Substitution Principle (LSP)

- TaskRepositoryImpl can replace TaskRepository interface
- TaskModel extends Task entity properly

### Interface Segregation Principle (ISP)

- Repository interface only contains necessary methods
- Use cases are focused and specific

### Dependency Inversion Principle (DIP)

- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Presentation depends on Domain (abstractions)
- Data depends on Domain (abstractions)
