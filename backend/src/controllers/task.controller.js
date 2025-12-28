// FILE: backend/src/controllers/task.controller.js

const pool = require('../db');

async function getAllTasks(req, res) {
  try {
    const result = await pool.query('SELECT * FROM tasks ORDER BY created_at DESC');
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

async function createTask(req, res) {
  try {
    const { title, description, assigned_to, status } = req.body;

    if (!title) {
      return res.status(400).json({ error: 'Title is required' });
    }

    const client = await pool.connect();
    
    try {
      await client.query('BEGIN');

      const taskResult = await client.query(
        'INSERT INTO tasks (title, description, assigned_to, status) VALUES ($1, $2, $3, $4) RETURNING *',
        [title, description || null, assigned_to || null, status || 'created']
      );

      const task = taskResult.rows[0];

      await client.query(
        'INSERT INTO task_history (task_id, action) VALUES ($1, $2)',
        [task.id, 'CREATED']
      );

      await client.query('COMMIT');

      res.status(201).json(task);
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error creating task:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

async function getTaskById(req, res) {
  try {
    const { taskId } = req.params;

    const result = await pool.query(
      'SELECT * FROM tasks WHERE id = $1',
      [taskId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching task:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = { getAllTasks, createTask, getTaskById };

