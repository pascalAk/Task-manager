# Task Management Flutter App

A Flutter application that integrates with a Node.js backend API for managing tasks with history tracking.

## Features

- Task List: View all tasks with status badges and assigned users
- Task Status Update: Mark tasks as completed with visual feedback
- Task History: View complete history of actions for each task
- Pull-to-Refresh: Refresh task list by pulling down
- Loading States: Visual indicators during data fetching and updates
- Error Handling: User-friendly error messages with retry options
- Empty States: Clear messages when no data is available
- Navigation: Seamless navigation between task list and history screens

## Supported Platforms

- Android (Emulator and Physical Devices)
- Web (Chrome, Edge, Firefox)
- Desktop (Windows, macOS, Linux)

## Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Node.js backend server running on port 3000
- For Android: Android Studio with emulator or physical device
- For Web: Modern web browser
- For Desktop: Platform-specific build tools

## Setup

### 1. Install Dependencies

```bash
cd flutter_app
flutter pub get
```

### 2. Start the Backend Server

Ensure the backend server is running on port 3000. See the `backend/README.md` for detailed instructions.

```bash
cd ../backend
node src/server.js
```

The backend should be accessible at:
- Web/Desktop: `http://localhost:3000`
- Android Emulator: `http://10.0.2.2:3000` (automatically handled by the app)

### 3. Run the Flutter App

For Android Emulator:
```bash
flutter run
```

For Web:
```bash
flutter run -d chrome
# or
flutter run -d edge
```

For Desktop:
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Project Structure

```
lib/
├── main.dart                      # Main app entry point with task list screen
├── models/
│   ├── task.dart                 # Task data model
│   └── task_history.dart         # Task history data model
├── screens/
│   └── task_history_screen.dart  # Task history screen
└── services/
    └── api_service.dart          # API service with centralized base URL logic
```

## API Endpoints Used

The app communicates with the following backend endpoints:

- GET `/api/tasks` - Fetch all tasks
- PUT `/api/tasks/:taskId` - Update task status
- GET `/api/tasks/:taskId/history` - Fetch task history

## Networking Configuration

The app automatically switches the base URL based on the platform:

- Android Emulator: `http://10.0.2.2:3000` (maps to host's localhost)
- Web/Desktop: `http://localhost:3000`

This is handled centrally in `lib/services/api_service.dart`.

## UI/UX Features

### Status Badges
- CREATED: Blue badge
- IN-PROGRESS: Orange badge
- COMPLETED: Green badge

### Task History Icons
- CREATED: Blue circle with add icon
- UPDATED: Orange circle with edit icon
- COMPLETED: Green circle with check icon

### Button States
- "Complete" button is disabled when task status is already "completed"
- Loading indicator appears on button during status update
- Duplicate API calls are prevented on rapid taps

### Loading States
- Loading indicators appear while:
  - Fetching task list
  - Fetching task history
  - Updating task status

### Empty States
- Clear messages when:
  - No tasks are available
  - No history entries exist

### Error Handling
- User-friendly error messages
- Retry buttons for failed operations
- Network error detection and messaging

## Usage

1. View Tasks: The app opens to the task list screen showing all available tasks
2. View History: Tap any task card to view its complete history
3. Update Status: Tap the "Complete" button to mark a task as completed
4. Refresh: Pull down on the task list or tap the refresh icon in the app bar
5. Navigate Back: Use the back button or app bar back arrow to return from history screen

## Troubleshooting

### Connection Error
- Ensure backend server is running on port 3000
- For Android emulator, the app automatically uses `10.0.2.2:3000`
- For web, ensure CORS is enabled in the backend if needed
- Check firewall settings if connection fails

### No Tasks Showing
- Verify backend database has tasks
- Check backend API is accessible via browser: `http://localhost:3000/api/tasks`
- Review console logs for error messages

### Build Errors
- Run `flutter clean` and `flutter pub get` to refresh dependencies
- Ensure Flutter SDK version matches requirements
- Check platform-specific build tools are installed

### Hot Reload Issues
- Stop and restart the app if hot reload doesn't work
- Use `flutter run` to start fresh

## Development Notes

- The app uses Material Design 3
- All API calls are handled through the centralized `ApiService`
- State management uses Flutter's built-in `StatefulWidget` and `FutureBuilder`
- Error handling includes user-friendly messages and retry mechanisms
- The code follows Flutter best practices and conventions

## License

This project is part of an assignment submission.
