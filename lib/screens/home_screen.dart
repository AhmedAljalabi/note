import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../screens/add_note_screen.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  
 Row(
  children: [
    CircleAvatar(
      backgroundImage: AssetImage('assets/a6.jpg'),
      
    ),
    const SizedBox(width: 15),
    Text(
      "Welcome! Ahmed Aljalabi to the Note App",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    ),
  ],
),

        
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "By Date"),
            Tab(text: "By Category"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.blue),
              title: const Text('Manage Categories'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.tag, color: Colors.blue),
              title: const Text('Manage Tags'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tags');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildExpensesByDate(context),
          buildNotesByCategory(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AddNoteScreen())),
        tooltip: 'Add Note',
        child: const Icon(Icons.add ,color: Colors.white),
      ),
    );
  }

  Widget buildExpensesByDate(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {
        if (provider.notes.isEmpty) {
          return Center(
            child: Text("Click the + button to record expenses.",
                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          );
        }

        return ListView.builder(
          itemCount: provider.notes.length,
          itemBuilder: (context, index) {
            final notes = provider.notes[index];
            String formattedDate =
                DateFormat('MMM dd, yyyy').format(notes.date);
            return Dismissible(
              key: Key(notes.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.removeNotes(notes.id);
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.purple[50],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

                child: ListTile(
                  
                  title: Text("Category: ${getCategoryNameById(context, notes.categoryId)}"),

                  subtitle: Text( "Note: ${notes.note}",
                     style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),),

                  trailing: Text(formattedDate),

                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildNotesByCategory(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {
        if (provider.notes.isEmpty) {
          return Center(
            child: Text("Click the + button to record notes.",
                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          );
        }

        // Grouping note by category
        var grouped = groupBy(provider.notes, (Note e) => e.categoryId);
        return ListView(
          children: grouped.entries.map((entry) {
            String categoryName = getCategoryNameById(
                context, entry.key); // Ensure you implement this function
            String tagName = getTagNameById(
                context, entry.key); // Assuming all notes in the group have the same tag
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    categoryName + ": " + tagName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 95, 182),
                    ),
                  ),
                ),
                ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                  shrinkWrap:
                      true, // necessary to integrate a ListView within another ListView
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    Note notes = entry.value[index];
                    return ListTile(
                      leading:
                          Icon(Icons.note, color: Colors.grey[700]),
                      subtitle:
                          Text(notes.note,
                            style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold)),
                          trailing: Text(
                           DateFormat('MMM dd, yyyy').format(notes.date),
                            style: TextStyle(color: Colors.grey[600])),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // home_screen.dart
  String getCategoryNameById(BuildContext context, String categoryId) {
    var category = Provider.of<NoteProvider>(context, listen: false)
        .categories
        .firstWhere((cat) => cat.id == categoryId);
    return category.name;
  }

  String getTagNameById(BuildContext context, String tagId) {
    var tag = Provider.of<NoteProvider>(context, listen: false)
        .tags
        .firstWhere((t) => t.id == tagId);
    return tag.name;
  }
}
