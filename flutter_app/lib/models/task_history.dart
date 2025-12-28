class TaskHistory {
  final String id;
  final String taskId;
  final String action;
  final DateTime createdAt;

  TaskHistory({
    required this.id,
    required this.taskId,
    required this.action,
    required this.createdAt,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) {
    return TaskHistory(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      action: json['action'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'action': action,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

