import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_tag_dialog.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? initialNote;

  const AddNoteScreen({super.key, this.initialNote});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController _noteController;
  String? _selectedCategoryId;
  String? _selectedTagId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _noteController =
        TextEditingController(text: widget.initialNote?.note ?? '');
    _selectedDate = widget.initialNote?.date ?? DateTime.now();
    _selectedCategoryId = widget.initialNote?.categoryId;
    _selectedTagId = widget.initialNote?.tag;
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialNote == null ? 'Add Note' : 'Edit Note'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(_noteController, 'note', TextInputType.text),
            buildDateField(_selectedDate),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Adjust the padding as needed
              child: buildCategoryDropdown(noteProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Adjust the padding as needed
              child: buildTagDropdown(noteProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 241, 255, 38),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _saveNote,
          child: const Text('Save Note'),
        ),
      ),
    );
  }
  // Helper methods for building the form elements go here (omitted for brevity)

  void _saveNote() {
    if (_noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields!')));
      return;
    }

    final notes = Note(
      id: widget.initialNote?.id ??
          DateTime.now().toString(), // Assuming you generate IDs like this

      categoryId: _selectedCategoryId!,

      note: _noteController.text,
      date: _selectedDate,
      tag: _selectedTagId!,
    );

    // Calling the provider to add or update the note
    Provider.of<NoteProvider>(context, listen: false).addOrUpdateNote(notes);
    Navigator.pop(context);
  }

  // Helper method to build a text field
  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

// Helper method to build the date picker field
  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

// Helper method to build the category dropdown
  Widget buildCategoryDropdown(NoteProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(onAdd: (newCategory) {
              setState(() {
                _selectedCategoryId =
                    newCategory.id; // Automatically select the new category
                provider.addCategory(
                    newCategory); // Add to provider, assuming this method exists
              });
            }),
          );
        } else {
          setState(() => _selectedCategoryId = newValue);
        }
      },
      items: provider.categories.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList()
        ..add(const DropdownMenuItem(
          value: "New",
          child: Text("Add New Category"),
        )),
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
    );
  }

// Helper method to build the tag dropdown
  Widget buildTagDropdown(NoteProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTagId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddTagDialog(onAdd: (newTag) {
              provider.addTag(newTag); // Assuming you have an `addTag` method.
              setState(
                  () => _selectedTagId = newTag.id); // Update selected tag ID
            }),
          );
        } else {
          setState(() => _selectedTagId = newValue);
        }
      },
      items: provider.tags.map<DropdownMenuItem<String>>((tag) {
        return DropdownMenuItem<String>(
          value: tag.id,
          child: Text(tag.name),
        );
      }).toList()
        ..add(const DropdownMenuItem(
          value: "New",
          child: Text("Add New Tag"),
        )),
      decoration: const InputDecoration(
        labelText: 'Tag',
        border: OutlineInputBorder(),
      ),
    );
  }
}
