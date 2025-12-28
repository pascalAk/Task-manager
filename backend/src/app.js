// FILE: backend/src/app.js

const express = require('express');
const taskRoutes = require('./routes/task.routes');
const taskHistoryRoutes = require('./routes/taskHistory.routes');

const app = express();

// CORS middleware for web requests
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/tasks', taskRoutes);
app.use('/api/tasks', taskHistoryRoutes);

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.get('/', (req, res) => {
  res.json({
    message: 'Task Management API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      tasks: {
        getAll: 'GET /api/tasks',
        getById: 'GET /api/tasks/:id',
        create: 'POST /api/tasks',
        update: 'PUT /api/tasks/:id',
        history: 'GET /api/tasks/:id/history'
      }
    },
    documentation: 'See README.md for detailed API documentation'
  });
});

module.exports = app;

