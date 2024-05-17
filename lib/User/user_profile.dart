import 'package:flutter/material.dart';
//this needs more changes and firebase updates
class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Color(0xFF00A1F2),
            fontWeight: FontWeight.bold, // Make the text bold for the user profile
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00A1F2),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('https://wallpapers.com/images/hd/naruto-profile-pictures-sa1tekghfajrr928.jpg'),
),

              const SizedBox(height: 60),
              Material(
                color: Colors.transparent,
                child: ListView(
                  padding: EdgeInsets.zero, // Remove padding
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle onTap action for List 1
                      },
                      child: ListTile(
                        leading: Icon(Icons.email),
                        title: Text(
                          'User Email',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add gap between List 1 and List 2
                    InkWell(
                      onTap: () {
                        // Handle onTap action for List 2
                      },
                      child: ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text(
                          'Notification',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add gap between List 2 and List 3
                    InkWell(
                      onTap: () {
                        // Handle onTap action for List 3
                      },
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text(
                          'Clear Cache',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add gap between List 3 and List 4
                    InkWell(
                      onTap: () {
                        // Handle onTap action for List 4
                      },
                      child: ListTile(
                        leading: Icon(Icons.privacy_tip),
                        title: Text(
                          'Privacy Policy',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add gap between List 4 and List 5
                    InkWell(
                      onTap: () {
                        // Handle onTap action for List 5
                      },
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text(
                          'About',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Color(0xFFf0f2f5), // Change divider color to white
                      thickness: 1.5,
                      height: 0,
                      indent: 16,
                      endIndent: 16,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 150, // Set button width
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle logout action
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Button color
                            onPrimary: Colors.white, // Text color
                          ),
                          child: Text(
                            'Log Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
