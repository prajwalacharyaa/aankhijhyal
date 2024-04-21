import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimeWidget extends StatefulWidget {
  final String location;

  const TimeWidget({Key? key, required this.location, required String time, required String temperature, required bool active, required Map data}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  late String time = '';
  late String temperature = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    const apiKey = 'ebc4d8573cdb452a420c626b5f529bec'; // Replace with your API key
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=${widget.location}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          time = DateTime.now().toString();
          temperature = data['main']['temp'].toString();
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    if (time.isEmpty || temperature.isEmpty) {
      return const CircularProgressIndicator();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.wb_sunny,
              color: Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(
              '$temperature°C',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
