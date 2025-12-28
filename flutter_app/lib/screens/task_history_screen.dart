import 'package:flutter/material.dart';
import '../models/task_history.dart';
import '../services/api_service.dart';

class TaskHistoryScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;

  const TaskHistoryScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  Future<List<TaskHistory>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = ApiService.getTaskHistory(widget.taskId).catchError((error) {
        print('Error loading task history: $error');
        return <TaskHistory>[];
      });
    });
  }

  Color _getActionColor(String action) {
    switch (action.toUpperCase()) {
      case 'CREATED':
        return Colors.blue;
      case 'UPDATED':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toUpperCase()) {
      case 'CREATED':
        return Icons.add_circle;
      case 'UPDATED':
        return Icons.edit;
      case 'COMPLETED':
        return Icons.check_circle;
      default:
        return Icons.history;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Task History'),
            Text(
              widget.taskTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<TaskHistory>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading task history...'),
                ],
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            String errorMessage = 'Unable to load task history';
            if (snapshot.error.toString().contains('not found')) {
              errorMessage = 'Task not found. It may have been deleted.';
            } else if (snapshot.error.toString().contains('network') || 
                       snapshot.error.toString().contains('connection')) {
              errorMessage = 'Network error. Please check your connection.';
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
                        'Error loading task history',
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
                        onPressed: _loadHistory,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No history found'),
                  SizedBox(height: 8),
                  Text(
                    'This task has no history entries yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Data state - display history list
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final history = snapshot.data![index];
              final actionColor = _getActionColor(history.action);
              final actionIcon = _getActionIcon(history.action);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: actionColor,
                    child: Icon(actionIcon, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    history.action,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatTimestamp(history.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  trailing: Text(
                    '${history.createdAt.hour.toString().padLeft(2, '0')}:${history.createdAt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

