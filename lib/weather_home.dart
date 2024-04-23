import 'dart:convert';
import 'package:aankhijhyal/User/user_profile.dart';
import 'package:aankhijhyal/location_search.dart';
import 'package:aankhijhyal/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherService {
  // ignore: constant_identifier_names
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
    final response = await http.get(
        Uri.parse('$BASE_URL/weather?q=$location&appid=$apiKey&units=metric'));

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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LocationSelectionPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(-1.0, 0.0); // Change begin offset to -1.0
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    if (chosenLocation != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('chosen_location', chosenLocation);

      setState(() {
        _chosenLocation = chosenLocation;
      });
      _fetchWeather();
    }
  }

  _fetchWeather() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedLocation = prefs.getString('chosen_location');

      final location = _chosenLocation ?? savedLocation ?? 'Kathmandu';

      // If _chosenLocation is null and savedLocation is also null, then set _chosenLocation to 'Kathmandu'
      if (_chosenLocation == null && savedLocation == null) {
        setState(() {
          _chosenLocation = 'Kathmandu';
        });
        await prefs.setString('chosen_location', 'Kathmandu');
      }

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
    // ignore: use_build_context_synchronously
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
    _loadSelectedLocation();
    _fetchWeather();
  }

  _loadSelectedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('chosen_location');
    if (savedLocation != null) {
      setState(() {
        _chosenLocation = savedLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Align items to the start and end
              children: [
                const SizedBox(width: 15),
                InkWell(
                  onTap: _chooseLocation,
                  child: SvgPicture.asset(
                    'assets/images/location.svg',
                    width: 24,
                    height: 24,
                    color: const Color(0xFF00A1F2),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _chooseLocation,
                      child: Text(
                        _weather?.cityName ?? "Loading city...",
                        style: TextStyle(
                          color: _isScrolled
                              ? Colors.black
                              : const Color(0xFF00A1F2),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserProfile(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    color: Color(0xFF00A1F2),
                  ),
                ),
                const SizedBox(width: 0),
              ],
            ),
          ],
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
                      'feeling ${(_weather?.weatherCondition ?? "")}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${_weather?.temperature?.toStringAsFixed(0) ?? ""}°C',
                      style: const TextStyle(
                        fontSize: 76,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 0),
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
    return currentTime < sunrise || currentTime > sunset;
  }
}

void main() {
  runApp(const MaterialApp(
    home: WeatherPage(),
  ));
}
