// FILE: backend/src/controllers/taskUpdate.controller.js

const pool = require('../db');

async function updateTaskStatus(req, res) {
  try {
    const { taskId } = req.params;
    const { status, assigned_to } = req.body;

    if (!status && !assigned_to) {
      return res.status(400).json({ error: 'Status or assigned_to is required' });
    }

    const client = await pool.connect();
    
    try {
      await client.query('BEGIN');

      // Build dynamic update query
      const updates = [];
      const values = [];
      let paramIndex = 1;

      if (status) {
        updates.push(`status = $${paramIndex}`);
        values.push(status);
        paramIndex++;
      }

      if (assigned_to !== undefined) {
        updates.push(`assigned_to = $${paramIndex}`);
        values.push(assigned_to || null);
        paramIndex++;
      }

      updates.push(`updated_at = now()`);
      values.push(taskId);

      const updateResult = await client.query(
        `UPDATE tasks SET ${updates.join(', ')} WHERE id = $${paramIndex} RETURNING *`,
        values
      );

      if (updateResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ error: 'Task not found' });
      }

      await client.query(
        'INSERT INTO task_history (task_id, action) VALUES ($1, $2)',
        [taskId, 'UPDATED']
      );

      await client.query('COMMIT');

      res.json(updateResult.rows[0]);
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error updating task:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = updateTaskStatus;

