
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'note_repository.dart';
import 'note.dart';








class NoteDetailPage extends StatefulWidget {
  final Note note;
  final int index;








  NoteDetailPage({required this.note, required this.index});








  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}








class _NoteDetailPageState extends State<NoteDetailPage> {
  bool _isEditing = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Color _selectedColor = Colors.white;
  String _selectedEmoji = '🙂';
  String _selectedFeeling = 'Happy';








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








  final NoteRepository _noteRepository = NoteRepository();








  void _startEditing() {
    if (!_isEditing) {
      setState(() {
        _isEditing = true;
      });
    }
  }








  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop();
              },
              availableColors: _pastelColors,
            ),
          ),
        );
      },
    );
  }








  void _pickEmoji() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: ListView(
            children: _emojis.entries.map((entry) {
              return ListTile(
                leading: Text(
                  entry.key,
                  style: TextStyle(fontSize: 24),
                ),
                title: Text(entry.value),
                onTap: () {
                  setState(() {
                    _selectedEmoji = entry.key;
                    _selectedFeeling = entry.value;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }








  void _saveNote() async {
    String title = _titleController.text;
    String content = _contentController.text;
    if (title.isNotEmpty || content.isNotEmpty) {
      Note note = Note(
        id: widget.note.id,
        userId: widget.note.userId,
        title: title,
        content: content,
        color: _selectedColor.value, // Save color as int
        emoji: _selectedEmoji,
        feeling: _selectedFeeling,
      );
      if (widget.index == -1) {
        // Add new note
        await _noteRepository.createNote(note);
      } else {
        // Update existing note
        await _noteRepository.updateNote(note);
      }
      Navigator.pop(context, true); // Return true to indicate a change was made
    } else {
      // Show an error or validation message
      print('Title or content is empty');
    }
  }








  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
    _selectedColor = Color(widget.note.color); // Load color from int
    _selectedEmoji = widget.note.emoji;
    _selectedFeeling = widget.note.feeling;
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Write your note',
          style: TextStyle(
            fontWeight: FontWeight.w600, // Semi-bold
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check, size: 30, color: Colors.black),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0), // Adjust padding for better spacing
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // Semi-bold
                        color: Colors.black,
                        fontFamily: 'Serif',
                      ),
                      border: InputBorder.none, // Remove TextField border
                      contentPadding: EdgeInsets.all(0), // No extra padding inside TextField
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600, // Semi-bold
                      fontFamily: 'Serif',
                    ),
                    onChanged: (text) => _startEditing(),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0), // Adjust padding for better spacing
                    child: TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        border: InputBorder.none, // Remove TextField border
                        contentPadding: EdgeInsets.all(0), // No extra padding inside TextField
                      ),
                      maxLines: null,
                      minLines: 10,
                      style: TextStyle(
                        fontFamily: 'Serif',
                      ),
                      onChanged: (text) => _startEditing(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickEmoji,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), // Add padding
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Feeling: $_selectedFeeling', style: TextStyle(fontFamily: 'Serif')),
                            Text('Emoji: $_selectedEmoji', style: TextStyle(fontSize: 24, fontFamily: 'Serif')),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10, height: 40),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.color_lens, size: 30, color: Colors.black),
                        onPressed: _pickColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
