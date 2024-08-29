# django-flutter-todo-app

## To-Do App

This Flutter-based To-Do App allows users to manage their tasks efficiently by adding, updating, and deleting tasks. The app interacts with a Django REST API backend, demonstrating proficiency in API calls, state management, and data structures in Flutter.

### Features

* **Task Management:** Users can add new tasks, update task details, and delete tasks.
* **Task Status Toggle:** Users can mark tasks as completed or incomplete by toggling a checkbox.
* **Real-time Updates:** The app dynamically updates the task list based on the latest actions (add, edit, delete).
* **API Integration:** The app communicates with a Django backend via RESTful API to manage tasks.

### Built With

* Flutter: The frontend of the application is built using Flutter, a UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
* Django: The backend API is built using Django, a high-level Python web framework that encourages rapid development and clean, pragmatic design.
* ChangeNotifierProvider: Used for state management in Flutter to separate business logic from the UI, ensuring the app responds dynamically to user interactions.
* http: A package in Flutter used to make API calls to the backend, facilitating task management operations.

### Packages Used

**Flutter Packages**

* provider: ^6.1.2 - Used for state management.
* http: ^1.2.2 - Used for making HTTP requests.

**Python Packages (Django)**

* Django: ^5.1
* djangorestframework: ^3.15.2 - Provides the tools for building Web APIs in Django.

### How the App Was Built

**1. Backend Setup**

The backend was built using Django and Django REST Framework to provide a RESTful API for task management.

* Models were created to represent tasks, and views were developed to handle CRUD operations (Create, Read, Update, Delete).
* URL routes were defined to map API endpoints to the corresponding views.

**2. Frontend Development**

The frontend was developed in Flutter, with a focus on a clean and responsive UI.

* The `TaskProvider` class was used to manage the app's state, with `ChangeNotifier` to notify the UI of changes.
* The `http` package was used to send HTTP requests to the Django API for creating, updating, fetching, and deleting tasks.
* The app utilizes widgets like `ListView`, `Card`, `Checkbox`, and `IconButton` to display tasks and provide a user-friendly interface.

**3. State Management**

The `ChangeNotifierProvider` package was integrated to manage the state of tasks. This allows the app to reactively update the UI in response to user actions like adding a new task or updating a task's status.

### Getting Started

**Prerequisites**

* **Flutter SDK:** Ensure Flutter is installed on your system. (https://docs.flutter.dev/get-started/install)
* **Django Environment:** Python and Django installed with the necessary dependencies (https://docs.djangoproject.com/en/5.1/)

**Installation**

1. Clone the repository:

```bash
git clone https://github.com/ndourc/django-flutter-todo-app
cd <repository-directory>
```

2. Run the backend server

```bash
cd todo_backend
python manage.py runserver
```

3. Run the Flutter app

```bash
flutter pub get
flutter run
```
