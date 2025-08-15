class Note {
  final String id;
  final String categoryId;
  final String note;
  final DateTime date;
  final String tag; // Assuming you have a tag field


  Note({
    required this.id,
    required this.categoryId,
    required this.note,
    required this.date,
    required this.tag,
  });






 factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      categoryId: json['categoryId'],
      note: json['note'],
      date: DateTime.parse(json['date']),
      tag: json['tag'] ?? '', // Assuming tag is optional
    );
  }
  


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'note': note,
      'date': date.toIso8601String(),
      'tag': tag, // Assuming tag is a string
    };
  }



 }

 