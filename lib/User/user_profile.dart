import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context); // Navigate back to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            final User user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'User Profile',
                  style: TextStyle(
                    color: Color(0xFF00A1F2),
                  ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: [
                  GestureDetector(
                    onTap: () => _signOut(context),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF00A1F2),
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          user.photoURL ?? 'https://wallpapers.com/images/featured/naruto-profile-pictures-sa1tekghfajrr928.webp'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.displayName ?? 'Username',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email ?? 'Email Address',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // User is not signed in, navigate to authentication page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserAuthentication(),
              ),
            );
            return const SizedBox(); // Placeholder until navigation completes
          }
        }
      },
    );
  }
}

class UserAuthentication extends StatelessWidget {
  const UserAuthentication({Key? key}) : super(key: key);

  // Implement the sign-in with Google logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement the sign-in with Google logic
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UserProfile(),
  ));
}
