// FILE: backend/src/controllers/taskHistory.controller.js

const pool = require('../db');

async function getTaskHistory(req, res) {
  try {
    const { taskId } = req.params;

    const result = await pool.query(
      'SELECT * FROM task_history WHERE task_id = $1 ORDER BY created_at DESC',
      [taskId]
    );

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching task history:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = getTaskHistory;

