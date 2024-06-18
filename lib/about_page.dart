import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to myNotes!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your Personal Notes App',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 1, 0, 3),
                    
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '• Create and manage notes\n'
                        '• Organize notes by categories\n'
                        '• Search for notes quickly\n'
                        '• Sync notes across devices\n'
                        '• Secure your notes with a passcode\n'
                        '• Dark mode for night use',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 83, 59, 50),
                          
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developed by:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Damia.co',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                          fontFamily: 'ComicSans',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Thank you for using myNotes!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'ComicSans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
