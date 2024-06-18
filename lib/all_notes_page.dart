import 'package:flutter/material.dart';
import 'note_repository.dart';
import 'note_detail_page.dart';
import 'settings_page.dart';
import 'note.dart';
import 'login_page.dart'; // Add this import

class AllNotesPage extends StatefulWidget {
  final int userId;

  AllNotesPage({required this.userId});

  @override
  _AllNotesPageState createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  Set<int> selectedNotes = {};
  bool isGridView = false;
  bool isSelectionMode = false;
  bool isNewestFirst = true; // Default to newest first
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // New fields for filtering
  String selectedEmoji = '';
  Color? selectedColor;

  final _noteRepository = NoteRepository();

  final List<Color> _pastelColors = [
    Color(0xFFFFF0F0), // Pink pastel
    Color(0xFFFFD9D9), // Light pink pastel
    Color(0xFFFFE0C9), // Light orange pastel
    Color(0xFFFFF5E0), // Light yellow pastel
    Color(0xFFFFFBE7), // Light cream pastel
    Color(0xFFE0F7FA), // Light cyan pastel
    Color(0xFFE0F2F1), // Light teal pastel
    Color(0xFFE8F5E9), // Light green pastel
    Color(0xFFE3F2FD), // Light blue pastel
    Color(0xFFEDE7F6), // Light lavender pastel
    Color(0xFFF3E5F5), // Light purple pastel
    Color(0xFFF8BBD0), // Light pink pastel
    Color(0xFFFFECB3), // Light amber pastel
    Color(0xFFD7CCC8), // Light brown pastel
    Color(0xFFBCAAA4), // Medium brown pastel
    Color(0xFFC8E6C9), // Pastel green
    Color(0xFFA5D6A7), // Medium pastel green
    Color(0xFFB3E5FC), // Light sky blue pastel
    Color(0xFF81D4FA), // Sky blue pastel
    Color(0xFFCFD8DC), // Light blue-grey pastel
  ];

  final Map<String, String> _emojis = {
    '😊': 'Content',
    '😢': 'Sad',
    '😔': 'Disappointed',
    '😠': 'Angry',
    '😡': 'Enraged',
    '😩': 'Exhausted',
    '😫': 'Tired',
    '😂': 'Joyful',
    '😍': 'Loving',
    '😎': 'Cool',
    '😳': 'Embarrassed',
    '😇': 'Blessed',
    '😒': 'Unamused',
    '😞': 'Disheartened',
    '😤': 'Annoyed',
    '🤔': 'Thoughtful',
    '😴': 'Sleepy',
    '🤗': 'Hugging',
    '🤐': 'Speechless',
    '😜': 'Playful',
    '😕': 'Confused',
    '🙄': 'Eye Roll',
    '😬': 'Grimacing',
    '😌': 'Relieved',
    '🤒': 'Sick',
    '🤢': 'Nauseated',
    '🤧': 'Sneezing',
    '🥳': 'Celebrating',
    '🥺': 'Pleading',
    '🤠': 'Adventurous',
    '🤡': 'Clownish',
    '🤥': 'Lying',
    '🤫': 'Shushing',
    '🤭': 'Giggling',
    '🧐': 'Inquisitive',
    '🤓': 'Nerdy',
    '😈': 'Mischievous',
    '🤤': 'Drooling',
    '🥵': 'Hot',
    '🥶': 'Cold',
    '🤩': 'Star-Struck',
    '😱': 'Shocked',
    '😨': 'Fearful',
    '😰': 'Anxious',
    '😥': 'Relieved',
    '😓': 'Downcast',
    '😖': 'Confounded',
    '😣': 'Persevering',
    '😟': 'Worried',
    '😏': 'Smirking',
    '😲': 'Astonished',
    '😦': 'Frowning',
    '😧': 'Anguished',
    '😪': 'Sleepy',
    '😮': 'Open-mouthed',
    '😯': 'Hushed',
    '😵': 'Dizzy',
    '😷': 'Masked',
  };

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  Future<void> _loadNotes() async {
    notes = await _noteRepository.getNotes(widget.userId);
    _sortNotes(); // Sort notes when loaded
    setState(() {
      filteredNotes = notes;
    });
  }

  void _sortNotes() {
    if (isNewestFirst) {
      notes.sort((a, b) => b.id!.compareTo(a.id!)); // Sort by newest first
    } else {
      notes.sort((a, b) => a.id!.compareTo(b.id!)); // Sort by oldest first
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterNotes);
    _searchController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void _enterSelectionMode() {
    setState(() {
      isSelectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedNotes.clear();
    });
  }

  void _deleteSelectedNotes() async {
    List<int> idsToDelete = selectedNotes.toList();
    for (int id in idsToDelete) {
      await _noteRepository.deleteNote(id);
    }
    await _loadNotes();
    _exitSelectionMode();
  }

  void _filterNotes() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(searchQuery) ||
               note.content.toLowerCase().contains(searchQuery) ||
               note.feeling.toLowerCase().contains(searchQuery);
      }).toList();
      _applyEmojiAndColorFilter(); // Apply additional filters
    });
  }

  void _applyEmojiAndColorFilter() {
    setState(() {
      // Start with all notes filtered by the search query
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(searchQuery) ||
               note.content.toLowerCase().contains(searchQuery) ||
               note.feeling.toLowerCase().contains(searchQuery);
      }).toList();

      // Further filter by emoji and color
      filteredNotes = filteredNotes.where((note) {
        final matchesEmoji = selectedEmoji.isEmpty || note.emoji == selectedEmoji;
        final matchesColor = selectedColor == null || note.color == selectedColor!.value;
        return matchesEmoji && matchesColor;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      selectedEmoji = '';
      selectedColor = null;
      _applyEmojiAndColorFilter();
    });
  }

  TextSpan highlightText(String text, String query) {
    if (query.isEmpty) {
      return TextSpan(text: text, style: TextStyle(color: Colors.black));
    }
    final String lowerCaseText = text.toLowerCase();
    final String lowerCaseQuery = query.toLowerCase();
    List<TextSpan> spans = [];
    int start = 0;
    int index;
    while ((index = lowerCaseText.indexOf(lowerCaseQuery, start)) != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: TextStyle(color: Colors.black)));
      }
      spans.add(TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(backgroundColor: Colors.yellow, color: Colors.black)));
      start = index + query.length;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: TextStyle(color: Colors.black)));
    }
    return TextSpan(children: spans);
  }

  void _editNote(Note note, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note, index: index),
      ),
    ).then((_) {
      _loadNotes();
    });
  }

  void _toggleSortOrder() {
    setState(() {
      isNewestFirst = !isNewestFirst;
      _sortNotes();
      filteredNotes = notes; // Update filteredNotes after sorting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedNotes,
            ),
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: Icon(isNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: _toggleSortOrder,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Notes',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search your notes...',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 143, 141, 141)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isGridView ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteDetailPage(note: Note(
                userId: widget.userId,
                title: '',
                content: '',
                color: Colors.white.value,
                emoji: '🙂',
                feeling: 'Happy',
              ), index: -1)),
            ).then((_) {
              _loadNotes();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  // Method to show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.black, width: 2.0),
          ),
          title: Text('Filter Notes'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select Emoji'),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedEmoji.isEmpty ? null : selectedEmoji,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  items: _emojis.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        children: [
                          Text(entry.key, style: TextStyle(fontSize: 24)),
                          SizedBox(width: 10),
                          Text(entry.value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedEmoji = newValue!;
                      _applyEmojiAndColorFilter();
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Select Color'),
                SizedBox(height: 10),
                DropdownButtonFormField<Color>(
                  value: selectedColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  items: _pastelColors.map((Color value) {
                    return DropdownMenuItem<Color>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            color: value,
                          ),
                          SizedBox(width: 10),
                          Text(value.toString().split('(0x')[1].split(')')[0]), // Display the color value as text
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedColor = newValue!;
                      _applyEmojiAndColorFilter();
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearFilters();
                Navigator.of(context).pop();
              },
              child: Text('Clear', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedNotes.contains(filteredNotes[index].id!);
        return GestureDetector(
          onLongPress: () {
            _enterSelectionMode();
            setState(() {
              selectedNotes.add(filteredNotes[index].id!);
            });
          },
          onTap: isSelectionMode
              ? () {
                  setState(() {
                    if (isSelected) {
                      selectedNotes.remove(filteredNotes[index].id!);
                      if (selectedNotes.isEmpty) {
                        _exitSelectionMode();
                      }
                    } else {
                      selectedNotes.add(filteredNotes[index].id!);
                    }
                  });
                }
              : () => _editNote(filteredNotes[index], index),
          child: Container(
            height: 150, // Set a fixed height for all notes
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Card(
              color: isSelected ? Colors.grey[300] : Color(filteredNotes[index].color),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filteredNotes[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Make title bold
                      overflow: TextOverflow.ellipsis, // Ensure the title fits in one line
                    ),
                    Expanded(
                      child: RichText(
                        text: highlightText(filteredNotes[index].content, searchQuery),
                        maxLines: 3, // Limit to 3 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis to overflowing text
                      ),
                    ),
                    Row(
                      children: [
                        // Removed the 'Feeling:' label to prevent overflow
                        Expanded(
                          child: Text(
                            filteredNotes[index].emoji,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedNotes.contains(filteredNotes[index].id!);
        return GestureDetector(
          onLongPress: () {
            _enterSelectionMode();
            setState(() {
              selectedNotes.add(filteredNotes[index].id!);
            });
          },
          onTap: isSelectionMode
              ? () {
                  setState(() {
                    if (isSelected) {
                      selectedNotes.remove(filteredNotes[index].id!);
                      if (selectedNotes.isEmpty) {
                        _exitSelectionMode();
                      }
                    } else {
                      selectedNotes.add(filteredNotes[index].id!);
                    }
                  });
                }
              : () => _editNote(filteredNotes[index], index),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Card(
              color: isSelected ? Colors.grey[300] : Color(filteredNotes[index].color),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filteredNotes[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Make title bold
                      overflow: TextOverflow.ellipsis, // Ensure the title fits in one line
                    ),
                    Expanded(
                      child: RichText(
                        text: highlightText(filteredNotes[index].content, searchQuery),
                        maxLines: 3, // Limit to 3 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis to overflowing text
                      ),
                    ),
                    Row(
                      children: [
                        // Removed the 'Feeling:' label to prevent overflow
                        Expanded(
                          child: Text(
                            filteredNotes[index].emoji,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
