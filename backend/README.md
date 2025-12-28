# Task Management API

A RESTful API for managing tasks with history tracking, built with Node.js, Express, and PostgreSQL (Supabase).

## Tech Stack

- Runtime: Node.js
- Framework: Express.js
- Database: PostgreSQL (via Supabase)
- Database Client: pg (node-postgres)
- Environment: dotenv

## Project Structure

```
backend/
├── src/
│   ├── controllers/
│   │   ├── task.controller.js          # Task CRUD operations
│   │   ├── taskUpdate.controller.js    # Task status updates
│   │   └── taskHistory.controller.js  # Task history retrieval
│   ├── routes/
│   │   ├── task.routes.js              # Task routes
│   │   └── taskHistory.routes.js      # Task history routes
│   ├── db.js                           # PostgreSQL connection pool
│   ├── app.js                          # Express app configuration
│   └── server.js                       # Server startup
├── package.json
├── .env                                # Environment variables (not in git)
└── schema.sql                          # Database schema
```

## Setup Steps

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the `backend` directory:

```env
PORT=3000
DATABASE_URL=postgresql://user:password@host:port/database
```

For Supabase:
```env
PORT=3000
DATABASE_URL=postgresql://postgres:your_password@db.your-project.supabase.co:5432/postgres
```

Note: If your password contains special characters (like `@`), URL-encode them:
- `@` becomes `%40`
- Example: `password@123` becomes `password%40123`

### 3. Create Database Tables

Run the SQL schema to create the required tables:

```bash
psql -U postgres -d your_database -f schema.sql
```

Or execute the SQL in `schema.sql` directly in your database client.

### 4. Start the Server

```bash
node src/server.js
```

The server will start on port 3000 (or the port specified in `.env`).

## API Endpoints

### Health Check
- GET `/health`
- Returns server status

### Tasks

- GET `/api/tasks`
  - Get all tasks
  - Returns: Array of task objects

- GET `/api/tasks/:id`
  - Get a single task by ID
  - Returns: Task object or 404 if not found

- POST `/api/tasks`
  - Create a new task
  - Body: `{ "title": "string", "description": "string", "assigned_to": "string", "status": "string" }`
  - Returns: Created task object (201)
  - Automatically creates a history entry with action "CREATED"

- PUT `/api/tasks/:id`
  - Update task status
  - Body: `{ "status": "string" }`
  - Returns: Updated task object (200) or 404 if not found
  - Automatically creates a history entry with action "UPDATED"

### Task History

- GET `/api/tasks/:id/history`
  - Get task history for a specific task
  - Returns: Array of history entries ordered by created_at DESC

## Request/Response Examples

### Create Task
```bash
POST http://localhost:3000/api/tasks
Content-Type: application/json

{
  "title": "Complete project documentation",
  "description": "Write comprehensive API documentation",
  "assigned_to": "Tauseef",
  "status": "created"
}
```

### Get All Tasks
```bash
GET http://localhost:3000/api/tasks
```

### Get Single Task
```bash
GET http://localhost:3000/api/tasks/{taskId}
```

### Update Task Status
```bash
PUT http://localhost:3000/api/tasks/{taskId}
Content-Type: application/json

{
  "status": "in-progress"
}
```

### Get Task History
```bash
GET http://localhost:3000/api/tasks/{taskId}/history
```

## Database Schema

### tasks table
- `id` (UUID, Primary Key)
- `title` (TEXT, Required)
- `description` (TEXT)
- `assigned_to` (TEXT)
- `status` (TEXT, Default: 'created')
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### task_history table
- `id` (UUID, Primary Key)
- `task_id` (UUID, Foreign Key → tasks.id)
- `action` (TEXT, Required)
- `created_at` (TIMESTAMP)

## Testing

Use Thunder Client or any REST client to test the API endpoints.

## Error Handling

The API returns standard HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request (missing required fields)
- `404` - Not Found
- `500` - Internal Server Error

All errors return JSON format:
```json
{
  "error": "Error message"
}
```

## Notes

- All SQL queries use parameterized statements to prevent SQL injection
- Task creation and updates use database transactions for data consistency
- Task history is automatically tracked on create and update operations
- The `.env` file should never be committed to version control
