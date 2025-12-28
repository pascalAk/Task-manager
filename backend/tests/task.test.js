// FILE: backend/tests/task.test.js

const request = require('supertest');
const app = require('../src/app');

// Mock the database pool
jest.mock('../src/db', () => {
  const mockPool = {
    query: jest.fn(),
    connect: jest.fn(),
  };
  return mockPool;
});

const pool = require('../src/db');

describe('Task API Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('GET /health', () => {
    it('should return status 200 and { status: "ok" }', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body).toEqual({ status: 'ok' });
    });
  });

  describe('GET /api/tasks', () => {
    it('should return status 200 and array response', async () => {
      const mockTasks = [
        {
          id: 1,
          title: 'Test Task 1',
          description: 'Description 1',
          assigned_to: 'User 1',
          status: 'created',
          created_at: '2024-01-01T00:00:00.000Z',
          updated_at: '2024-01-01T00:00:00.000Z'
        },
        {
          id: 2,
          title: 'Test Task 2',
          description: 'Description 2',
          assigned_to: 'User 2',
          status: 'in-progress',
          created_at: '2024-01-02T00:00:00.000Z',
          updated_at: '2024-01-02T00:00:00.000Z'
        }
      ];

      pool.query.mockResolvedValue({ rows: mockTasks });

      const response = await request(app)
        .get('/api/tasks')
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
      expect(response.body.length).toBe(2);
      expect(response.body[0]).toHaveProperty('id');
      expect(response.body[0]).toHaveProperty('title');
      expect(response.body[0]).toHaveProperty('status');
    });
  });

  describe('POST /api/tasks', () => {
    it('should create a task and return status 201', async () => {
      const newTask = {
        id: 3,
        title: 'New Task',
        description: 'New Description',
        assigned_to: 'New User',
        status: 'created',
        created_at: '2024-01-03T00:00:00.000Z',
        updated_at: '2024-01-03T00:00:00.000Z'
      };

      const mockClient = {
        query: jest.fn(),
        release: jest.fn(),
      };

      pool.connect.mockResolvedValue(mockClient);
      mockClient.query
        .mockResolvedValueOnce({ rows: [] }) // BEGIN
        .mockResolvedValueOnce({ rows: [newTask] }) // INSERT task
        .mockResolvedValueOnce({ rows: [] }) // INSERT history
        .mockResolvedValueOnce({ rows: [] }); // COMMIT

      const response = await request(app)
        .post('/api/tasks')
        .send({
          title: 'New Task',
          description: 'New Description',
          assigned_to: 'New User',
          status: 'created'
        })
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body).toHaveProperty('title', 'New Task');
      expect(response.body).toHaveProperty('status', 'created');
      expect(mockClient.query).toHaveBeenCalledWith('BEGIN');
      expect(mockClient.query).toHaveBeenCalledWith('COMMIT');
    });

    it('should return 400 if title is missing', async () => {
      const response = await request(app)
        .post('/api/tasks')
        .send({
          description: 'No title task',
          status: 'created'
        })
        .expect(400);

      expect(response.body).toHaveProperty('error', 'Title is required');
    });
  });
});

