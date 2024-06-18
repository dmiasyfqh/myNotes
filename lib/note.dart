class Note {
  final int? id;
  final int userId;
  final String title;
  final String content;
  final int color;
  final String emoji;
  final String feeling;
  final DateTime? date;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.color,
    required this.emoji,
    required this.feeling,
    this.date, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'color': color,
      'emoji': emoji,
      'feeling': feeling,
      'date': date?.toIso8601String(), // Add this line
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      emoji: map['emoji'],
      feeling: map['feeling'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null, // Add this line
    );
  }
}
