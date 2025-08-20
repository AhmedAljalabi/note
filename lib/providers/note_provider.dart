import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../models/tag.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class NoteProvider with ChangeNotifier {
  final LocalStorage storage;

  List<Note> _notes = [];

  final List<NoteCategory> _categories = [
    NoteCategory(id: '1', name: 'Food', isDefault: true),
    NoteCategory(id: '2', name: 'Transport', isDefault: true),
    NoteCategory(id: '3', name: 'Entertainment', isDefault: true),
    NoteCategory(id: '4', name: 'Office', isDefault: true),
    NoteCategory(id: '5', name: 'Gym', isDefault: true),
  ];

  final List<Tag> _tags = [
    Tag(id: '1', name: 'Breakfast'),
    Tag(id: '2', name: 'Lunch'),
    Tag(id: '3', name: 'Dinner'),
    Tag(id: '4', name: 'Treat'),
    Tag(id: '5', name: 'Cafe'),
    Tag(id: '6', name: 'Restaurant'),
    Tag(id: '7', name: 'Train'),
    Tag(id: '8', name: 'Vacation'),
    Tag(id: '9', name: 'Birthday'),
    Tag(id: '10', name: 'Diet'),
    Tag(id: '11', name: 'MovieNight'),
    Tag(id: '12', name: 'Tech'),
    Tag(id: '13', name: 'CarStuff'),
    Tag(id: '14', name: 'SelfCare'),
    Tag(id: '15', name: 'Streaming'),
  ];

  List<Note> get notes => _notes;
  List<NoteCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  NoteProvider(this.storage){ _loadNotesFromStorage();}

  Future<void> init() async {
    await _loadNotesFromStorage();
  }

  Future<void> _loadNotesFromStorage() async {
    var storedNotes = storage.getItem('notes');
    if (storedNotes != null) {
      List<dynamic> decoded = jsonDecode(storedNotes);
      _notes = decoded.map((item) => Note.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void _saveNotesToStorage() {
    storage.setItem(
      'notes',
      jsonEncode(_notes.map((e) => e.toJson()).toList()),
    );
  }

  void addNote(Note note) {
    _notes.add(note);
    _saveNotesToStorage();
    notifyListeners();
  }

  void addOrUpdateNote(Note note) {
    int index = _notes.indexWhere((e) => e.id == note.id);
    if (index != -1) {
      _notes[index] = note;
    } else {
      _notes.add(note);
    }
    _saveNotesToStorage();
    notifyListeners();
  }

  void deleteNotes(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotesToStorage();
    notifyListeners();
  }

  void addCategory(NoteCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }

  void removeNotes(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotesToStorage();
    notifyListeners();
  }
}