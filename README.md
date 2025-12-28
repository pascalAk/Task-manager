# Task Management System

A full-stack task management application with a Node.js backend API and Flutter mobile/web/desktop application. This project provides a complete solution for managing tasks with history tracking capabilities.

## Project Overview

This project consists of two main components:

1. **Backend API** - A RESTful Node.js server built with Express.js and PostgreSQL
2. **Flutter Application** - A cross-platform mobile, web, and desktop application

## Project Structure

```
assignment-2/
├── backend/          # Node.js backend API
└── flutter_app/      # Flutter cross-platform application
```

## Features

- Create, read, and update tasks
- Task status management (created, in-progress, completed)
- Complete task history tracking
- Cross-platform Flutter application (Android, iOS, Web, Windows, macOS, Linux)
- Real-time task updates
- User-friendly error handling
- Pull-to-refresh functionality

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Flutter SDK (3.10.4 or higher)
- PostgreSQL database (or Supabase account)
- Git

### Backend Setup

Navigate to the backend directory and follow the setup instructions in `backend/README.md`:

```bash
cd backend
npm install
```

Create a `.env` file with your database configuration. You'll need to set up your PostgreSQL connection string or use Supabase. Then start the server:

```bash
npm start
# or for development
npm run dev
```

The backend API will be available at `http://localhost:3000`

#### Running Tests

The backend includes unit tests using Jest and Supertest. To run the tests:

```bash
cd backend
npm test
```

The test suite covers API endpoints including health checks, task retrieval, and task creation. All tests should pass before deployment.

### Flutter App Setup

Navigate to the Flutter app directory:

```bash
cd flutter_app
flutter pub get
```

Run the application on your preferred platform:

```bash
# Android
flutter run

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Documentation

- Backend documentation: See `backend/README.md` for API endpoints, setup instructions, and database schema
- Flutter app documentation: See `flutter_app/README.md` for app features, usage, and troubleshooting

## Technology Stack

### Backend
- Node.js
- Express.js
- PostgreSQL (via Supabase)
- pg (node-postgres)
- Jest & Supertest (for unit testing)

### Frontend
- Flutter
- Dart
- Material Design 3
- HTTP package for API communication

## Live Backend

The backend API is deployed and live on Render. You can access it at:

- Base URL: https://task-manager-eba2.onrender.com
- Health Check: https://task-manager-eba2.onrender.com/health

The backend is fully functional and ready to handle requests from the Flutter application. All API endpoints are available at the deployed URL.

## Flutter App

The Flutter application connects to the live backend and provides a complete task management interface. The app includes:

- Task List: Displays all tasks fetched from the live backend, showing task title, status badges, and assigned user information
- Status Updates: Allows users to update task status to completed with visual feedback and loading indicators
- Task History: Provides a detailed timeline view of all actions performed on each task, including creation, updates, and completion events
- Pull-to-Refresh: Enables users to refresh the task list by pulling down on the screen
- Error Handling: Shows user-friendly error messages with retry options
- Empty States: Displays clear messages when no tasks or history entries are available

The app automatically connects to the deployed backend and works seamlessly across all supported platforms.

## Screenshots

Screenshots of the Flutter application are available in the `flutter_app/screenshots/` directory:

- `task_list.png` - The task list screen showing all available tasks with their status badges and assigned users
- `task_history.png` - The task history screen displaying the complete timeline of actions for a selected task

These screenshots demonstrate the app's UI and functionality across different screens.

## API Endpoints

The backend provides the following RESTful endpoints:

### Health Check
- **GET** `/health` - Returns server health status
  - Example: `GET https://task-manager-eba2.onrender.com/health`
  - Response: `{ "status": "ok" }`

### Tasks
- **GET** `/api/tasks` - Get all tasks
  - Example: `GET https://task-manager-eba2.onrender.com/api/tasks`
  - Returns: Array of task objects

- **GET** `/api/tasks/:id` - Get a single task by ID
  - Example: `GET https://task-manager-eba2.onrender.com/api/tasks/1`
  - Returns: Single task object or 404 if not found

- **POST** `/api/tasks` - Create a new task
  - Example: `POST https://task-manager-eba2.onrender.com/api/tasks`
  - Body: `{ "title": "Task title", "description": "Task description", "assigned_to": "User name", "status": "created" }`
  - Returns: Created task object (201) or error (400/500)

- **PUT** `/api/tasks/:id` - Update task status
  - Example: `PUT https://task-manager-eba2.onrender.com/api/tasks/1`
  - Body: `{ "status": "completed" }`
  - Returns: Updated task object (200) or error (404/500)

- **GET** `/api/tasks/:id/history` - Get task history
  - Example: `GET https://task-manager-eba2.onrender.com/api/tasks/1/history`
  - Returns: Array of history entries for the task

## Contributing

This is an assignment project. For questions or issues, please refer to the individual component README files.

## License

This project is part of an assignment submission.

## Live Backend URL

The backend API is deployed on Render:

https://task-manager-eba2.onrender.com

Health check:
https://task-manager-eba2.onrender.com/health

