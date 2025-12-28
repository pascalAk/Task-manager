import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/api_service.dart';
import 'screens/task_history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<List<Task>>? _tasksFuture;
  String? _updatingTaskId;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasksFuture = ApiService.getTasks().catchError((error) {
        print('Error loading tasks: $error');
        return <Task>[];
      });
    });
  }

  Future<void> _updateTaskStatus(Task task) async {
    // Prevent duplicate API calls
    if (_updatingTaskId != null) {
      return;
    }

    setState(() {
      _updatingTaskId = task.id;
    });

    try {
      await ApiService.updateTaskStatus(task.id, 'completed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task status updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadTasks();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to update task status';
        if (e.toString().contains('not found')) {
          errorMessage = 'Task not found. Please refresh the list.';
        } else if (e.toString().contains('network') || e.toString().contains('connection')) {
          errorMessage = 'Network error. Please check your connection.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingTaskId = null;
        });
      }
    }
  }

  void _navigateToTaskHistory(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskHistoryScreen(
          taskId: task.id,
          taskTitle: task.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading tasks...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            String errorMessage = 'Unable to load tasks';
            if (snapshot.error.toString().contains('network') || 
                snapshot.error.toString().contains('connection') ||
                snapshot.error.toString().contains('Failed host lookup')) {
              errorMessage = 'Cannot connect to server. Please ensure the backend is running on port 3000.';
            } else if (snapshot.error.toString().contains('404')) {
              errorMessage = 'Server endpoint not found. Please check the API configuration.';
            }

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading tasks',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTasks,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tasks found'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadTasks();
              // Wait for the future to complete
              await _tasksFuture;
            },
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                final isCompleted = task.status.toLowerCase() == 'completed';
                final isUpdating = _updatingTaskId == task.id;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () => _navigateToTaskHistory(task),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(task.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  task.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (task.assignedTo != null) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.assignedTo!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      trailing: isUpdating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : ElevatedButton(
                              onPressed: isCompleted ? null : () => _updateTaskStatus(task),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCompleted ? Colors.grey : Colors.blue,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                disabledForegroundColor: Colors.grey[600],
                              ),
                              child: const Text('Complete'),
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.orange;
      case 'created':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
