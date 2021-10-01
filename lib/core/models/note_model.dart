class Note {
  int? id;
  String? title;
  String? content;
  int? color;
  String? date;
  String? time;
  String? editDate;
  String? editTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.date,
    required this.time,
    required this.editDate,
    required this.editTime
  });

  Note.fromMap(Map<String, dynamic>? map) {
    id = map?['id'];
    title = map?['title'];
    content = map?['content'];
    color = map?['color'];
    date = map?['date'];
    time = map?['time'];
    editDate = map?['editDate'];
    editTime = map?['editTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'date': date,
      'time': time,
      'editDate': editDate,
      'editTime': editTime
    };
  }
}
