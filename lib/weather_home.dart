import 'dart:convert';
import 'package:aankhijhyal/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nepali_utils/nepali_utils.dart';

class WeatherService {
  static const String BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> getWeatherByLocation(String location) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/weather?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WeatherPage> {
  final _weatherService = WeatherService('ebc4d8573cdb452a420c626b5f529bec');
  Weather? _weather;
  final bool _isScrolled = false;
  String? _chosenLocation;

  _chooseLocation() async {
    final chosenLocation = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => LocationSelectionPage()),
    );

    if (chosenLocation != null) {
      setState(() {
        _chosenLocation = chosenLocation;
      });
      _fetchWeather();
    }
  }

  _fetchWeather() async {
    try {
      final location = _chosenLocation ?? 'Kathmandu';
      final weather = await _weatherService.getWeatherByLocation(location);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather forecast: $e');
    }
  }

  String getCurrentNepaliDateTime() {
    NepaliDateTime dateTime = NepaliDateTime.now();
    NepaliDateFormat dateFormat = NepaliDateFormat('yyyy-MM-dd HH:mm:ss');
    String nepaliDateString = dateFormat.format(dateTime);

    NepaliDateTime convertedDate = NepaliDateTime.parse(nepaliDateString);

    NepaliDateFormat displayFormat = NepaliDateFormat('EEE, MMMM d, yyyy G.');

    String formattedDate = displayFormat.format(convertedDate);

    return formattedDate;
  }

  String getWeatherAnimation(String? mainCondition, bool isNightTime) {
    if (mainCondition == null) return 'assets/sunny.json';
    if (isNightTime) {
      switch (mainCondition.toLowerCase()) {
        case 'clouds':
          return 'assets/cloudnight.json';
        case 'rain':
          return 'assets/nightrain.json';
        case 'clear':
          return 'assets/clearnight.json';
        case 'thunderstorm':
          return 'assets/thunderstorm.json';
        case 'drizzle':
          return 'assets/nightrain.json';
        case 'snow':
          return 'assets/snow.json';
        case 'mist':
          return 'assets/mist.json';
        default:
          return 'assets/clearnight.json';
      }
    } else {
      switch (mainCondition.toLowerCase()) {
        case 'clouds':
          return 'assets/clouds.json';
        case 'rain':
          return 'assets/rain.json';
        case 'clear':
          return 'assets/sunny.json';
        case 'thunderstorm':
          return 'assets/thunderstorm.json';
        case 'drizzle':
          return 'assets/rain.json';
        case 'snow':
          return 'assets/snow.json';
        case 'mist':
          return 'assets/mist.json';
        default:
          return 'assets/sunny.json';
      }
    }
  }

  Future<void> _refreshWeather() async {
    await _fetchWeather();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Weather refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _chooseLocation,
                    child: Text(
                      _weather?.cityName ?? "Loading city...",
                      style: TextStyle(
                        color: _isScrolled ? Colors.black : const Color(0xFF00A1F2),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: _chooseLocation,
                    child: SvgPicture.asset(
                      'assets/images/location.svg',
                      width: 24,
                      height: 24,
                      color: const Color(0xFF00A1F2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: _isScrolled ? Colors.white : Colors.white,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Lottie.asset(
                      getWeatherAnimation(
                          _weather?.weatherCondition, _isNightTime()),
                    ),
                    const SizedBox(height: 0),
                    Text(
                      '${_weather?.temperature?.toStringAsFixed(0) ?? ""}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _weather?.weatherCondition ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    getCurrentNepaliDateTime(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNightTime() {
    if (_weather == null) return false;
    int sunrise = _weather!.sunrise ?? 0;
    int sunset = _weather!.sunset ?? 0;
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/
        1000; // Get current time in seconds
    return currentTime < sunrise ||
        currentTime > sunset;
  }
}

class LocationSelectionPage extends StatefulWidget {
  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter a location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text('Select Location'),
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

void main() {
  runApp(MaterialApp(
    home: WeatherPage(),
  ));
}
