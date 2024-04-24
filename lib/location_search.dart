import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  late TextEditingController _controller;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLocation = _prefs.getString('selectedLocation') ?? '';
    setState(() {
      _controller.text = savedLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(
            color: Color(0xFF00A1F2),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter a location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _prefs.setString('selectedLocation', _controller.text);
                Navigator.pop(
                  context,
                  _controller.text,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF00A1F2),
                onPrimary: Colors.white,
              ),
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
