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

Create a `.env` file with your database configuration, then start the server:

```bash
node src/server.js
```

The backend API will be available at `http://localhost:3000`

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

### Frontend
- Flutter
- Dart
- Material Design 3
- HTTP package for API communication

## API Endpoints

The backend provides the following endpoints:

- GET `/health` - Health check
- GET `/api/tasks` - Get all tasks
- GET `/api/tasks/:id` - Get a single task
- POST `/api/tasks` - Create a new task
- PUT `/api/tasks/:id` - Update task status
- GET `/api/tasks/:id/history` - Get task history

## Contributing

This is an assignment project. For questions or issues, please refer to the individual component README files.

## License

This project is part of an assignment submission.

