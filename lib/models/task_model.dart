class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  String status;
  String? blockedBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'blockedBy': blockedBy,
    };
  }

  factory Task.fromMap(Map map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      status: map['status'],
      blockedBy: map['blockedBy'],
    );
  }
}