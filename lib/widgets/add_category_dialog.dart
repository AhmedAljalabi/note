
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_category.dart';
import '../providers/note_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(NoteCategory) onAdd;

  const AddCategoryDialog({super.key, required this.onAdd});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Category'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Category Name',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            var newCategory = NoteCategory(
                id: DateTime.now().toString(), name: _controller.text);
            widget.onAdd(newCategory);
            Provider.of<NoteProvider>(context, listen: false).addCategory(newCategory);
            _controller.clear(); // Clear the input field
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
