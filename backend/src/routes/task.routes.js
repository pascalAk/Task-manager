// FILE: backend/src/routes/task.routes.js

const express = require('express');
const router = express.Router();
const { getAllTasks, createTask, getTaskById } = require('../controllers/task.controller');
const updateTaskStatus = require('../controllers/taskUpdate.controller');

router.get('/', getAllTasks);
router.post('/', createTask);
router.get('/:taskId', getTaskById);
router.put('/:taskId', updateTaskStatus);

module.exports = router;

