import 'dart:convert';
import 'package:aankhijhyal/weather_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugins are initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _location;
  late String _temperature;
  late String _weatherStatus;
  late String _airQualityIndex;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _location = 'Kathmandu';
    _temperature = '';
    _weatherStatus = '';
    _airQualityIndex = '';
    _loading = true;
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = 'ebc4d8573cdb452a420c626b5f529bec'; // Replace with your OpenWeatherMap API key
    const apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=Kathmandu&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _temperature = data['main']['temp'].toStringAsFixed(0); // Display temperature as whole number
          _weatherStatus = data['weather'][0]['main'].toString();
          _location = data['name'].toString(); // Update location based on API response
          _loading = false;
          if (data.containsKey('main') && data['main'].containsKey('aqi')) {
            _airQualityIndex = data['main']['aqi'].toString(); // Extract AQI value from API response
          } else {
            _airQualityIndex = 'N/A'; // Set as 'N/A' if AQI value is not available
          }
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _getWeatherIconPath(String weatherStatus) {
    switch (weatherStatus.toLowerCase()) {
      case 'thunderstorm':
        return 'assets/images/thunder.png';
      case 'drizzle':
        return 'assets/images/windwave.png';
      case 'rain':
        return 'assets/images/heavyRain.png';
      case 'snow':
        return 'assets/images/snow.png';
      case 'clear':
        return 'assets/images/sun.png';
      case 'clouds':
        return 'assets/images/star.png';
      default:
        return 'assets/images/sun.png'; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _location,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.blue],
          ),
        ),
        child: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      _getWeatherIconPath(_weatherStatus),
                      height: 210,
                      width: 210,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_temperature°C',
                      style: const TextStyle(fontSize: 60, color: Colors.white),
                    ),
                    Text(
                      _weatherStatus,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Air Quality Index: $_airQualityIndex',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
