// FILE: backend/src/routes/taskHistory.routes.js

const express = require('express');
const router = express.Router();
const getTaskHistory = require('../controllers/taskHistory.controller');

router.get('/:taskId/history', getTaskHistory);

module.exports = router;

