import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';
import '../models/task_history.dart';

class ApiService {
  static const String baseUrl = 'https://task-manager-eba2.onrender.com';

  static Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tasks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  static Future<Task> updateTaskStatus(String taskId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/tasks/$taskId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Task.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Task not found');
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  static Future<List<TaskHistory>> getTaskHistory(String taskId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tasks/$taskId/history'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TaskHistory.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Task not found');
      } else {
        throw Exception('Failed to load task history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task history: $e');
    }
  }
}

