import 'package:flutter/material.dart';
import 'user_authentication.dart'; // Import the UserAuthentication page

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Color(0xFF00A1F2),
          ),
        ),
        centerTitle: true, // Center the title
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Navigate back when wrong icon is tapped
            },
            child: Container(
              padding: const EdgeInsets.all(0),
              child: const Icon(
                Icons.close,
                color: Color(0xFF00A1F2),
                size: 30, // Increase the icon size
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://example.com/image.jpg'), // Add a network image for the user avatar
            ),
            SizedBox(height: 20),
            Text(
              'Username', // Display the username here
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email Address', // Display the email address here
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const UserProfile(),
  ));
}

class UserAuthentication extends StatelessWidget {
  const UserAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform authentication logic here
            // For example, sign in with Google
          },
          child: const Text('Sign In with Google'),
        ),
      ),
    );
  }
}
