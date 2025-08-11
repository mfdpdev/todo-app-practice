class Task {
  String id;
  String task;
  bool isDone;
  DateTime scheduleAt;

  Task({required this.id, required this.task, this.isDone = false, required this.scheduleAt});
}
