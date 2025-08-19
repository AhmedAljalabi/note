class NoteCategory {
  final String id;
  final String name;
  final bool isDefault;                                                                                                                                               
  NoteCategory({
    required this.id,
    required this.name,
    this.isDefault = false,
  });


 factory NoteCategory.fromJson(Map<String, dynamic> json) {
    return NoteCategory(
      id: json['id'],
      name: json['name'],
      isDefault: json['isDefault'] ?? false,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }                                                                                                                                                                                                                                                                                                                   




 }