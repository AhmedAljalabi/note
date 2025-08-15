import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../models/tag.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';


class NoteProvider with ChangeNotifier {
  final LocalStorage storage;
  // List of notes
// Removed duplicate unnamed constructor

  List<Note> _notes = [];

  // List of categories
  final List<NoteCategory> _categories = [
    NoteCategory(id: '1', name: 'Food', isDefault: true),
    NoteCategory(id: '2', name: 'Transport', isDefault: true),
    NoteCategory(id: '3', name: 'Entertainment', isDefault: true),
    NoteCategory(id: '4', name: 'Office', isDefault: true),
    NoteCategory(id: '5', name: 'Gym', isDefault: true),
  ];

  // List of tags
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

  // Getters
  List<Note> get notes => _notes;
  List<NoteCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  NoteProvider(this.storage) {
    _loadNotesFromStorage();
  }

  void _loadNotesFromStorage() async {
    // Wait for the storage to be ready
     Future.delayed;
    // Load notes from local storage
    var storedNotes = storage.getItem('notes');
    if (storedNotes != null) {
      _notes = List<Note>.from(
        (storedNotes as List).map((item) => Note.fromJson(item)),
      );
      notifyListeners();
    }
  }

  // Add a note
  void addNote(Note notes) {
    _notes.add(notes);
    _saveNotesToStorage();
    notifyListeners();
  }

  void _saveNotesToStorage() {
    storage.setItem(
        'notes', jsonEncode(_notes.map((e) => e.toJson()).toList()));
  }

  void addOrUpdateNote(Note notes) {
    int index = _notes.indexWhere((e) => e.id == notes.id);
    if (index != -1) {
      // Update existing note
      _notes[index] = notes;
    } else {
      // Add new note
      _notes.add(notes);
    }
    _saveNotesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete a note
  void deleteNotes(String id) {
    _notes.removeWhere((notes) => notes.id == id);
    _saveNotesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Add a category
  void addCategory(NoteCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  // Delete a category
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  // Add a tag
  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  // Delete a tag
  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }

  void removeNotes(String id) {
    _notes.removeWhere((notes) => notes.id == id);
    _saveNotesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }
}
