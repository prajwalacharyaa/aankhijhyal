// ignore_for_file: avoid_print

import 'package:aankhijhyal/models/weather_model.dart';
import 'package:aankhijhyal/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nepali_utils/nepali_utils.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WeatherPage> {
  final _weatherService = WeatherService('ebc4d8573cdb452a420c626b5f529bec');
  Weather? _weather;
  //for forecasting 7 days
 // List<Weather>? _forecast;
  final bool _isScrolled = false;

  // Fetch weather and forecast for Kathmandu, Nepal
  _fetchWeather() async {
    try {
      double kathmanduLatitude = 27.726877;
      double kathmanduLongitude = 85.405415;

      final weather = await _weatherService.getWeather(
          kathmanduLatitude, kathmanduLongitude);
     // final forecast = await _weatherService.getForecast(
     //     kathmanduLatitude, kathmanduLongitude);

      setState(() {
        _weather = weather;
      //  _forecast = forecast;
      });
    } catch (e) {
      print('Error fetching weather forecast: $e');
    }
  }
// Define a method to get the current Nepali date and time
String getCurrentNepaliDateTime() {
  NepaliDateTime dateTime = NepaliDateTime.now();
  NepaliDateFormat dateFormat = NepaliDateFormat('EEEE, MMMM d, yyyy, hh:mm a');
  return dateFormat.format(dateTime);
}
  // Weather animations
  String getWeatherAnimation(String? mainCondition, bool isNightTime) {
    if (mainCondition == null) return 'assets/sunny.json';
    if (isNightTime) {
      switch (mainCondition.toLowerCase()) {
        case 'clouds':
          return 'assets/cloudnight.json'; // Use night clouds animation for clouds at night
        case 'rain':
          return 'assets/nightrain.json'; // Use night rain animation for rain at night
        case 'clear':
          return 'assets/clearnight.json'; // Use night clear animation for clear skies at night
        case 'thunderstorm':
          return 'assets/thunderstorm.json'; // Use night thunderstorm animation for thunderstorm at night
        case 'drizzle':
          return 'assets/nightrain.json'; // Use night rain animation for drizzle at night
        case 'snow':
          return 'assets/snow.json'; // Use night snow animation for snow at night
        case 'mist':
          return 'assets/mist.json'; // Use night mist animation for mist at night
        default:
          return 'assets/clearnight.json'; // Use night clear animation as default at night
      }
    } else {
      switch (mainCondition.toLowerCase()) {
        case 'clouds':
          return 'assets/clouds.json'; // Use day clouds animation for clouds during the day
        case 'rain':
          return 'assets/rain.json'; // Use day rain animation for rain during the day
        case 'clear':
          return 'assets/sunny.json'; // Use day clear animation for clear skies during the day
        case 'thunderstorm':
          return 'assets/thunderstorm.json'; // Use day thunderstorm animation for thunderstorm during the day
        case 'drizzle':
          return 'assets/rain.json'; // Use day rain animation for drizzle during the day
        case 'snow':
          return 'assets/snow.json'; // Use day snow animation for snow during the day
        case 'mist':
          return 'assets/mist.json'; // Use day mist animation for mist during the day
        default:
          return 'assets/sunny.json'; // Use day sunny animation as default during the day
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
    _fetchWeather(); // Fetch weather on widget startup
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
              Text(
                _weather?.cityName ?? "Loading city...",
                style: TextStyle(
                  color: _isScrolled ? Colors.black : const Color(0xFF00A1F2),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                    // Animation
                    Lottie.asset(
                      getWeatherAnimation(
                          _weather?.weatherCondition, _isNightTime()),
                    ),
                    const SizedBox(height: 0),

                    // Temperature
                    Text(
                      '${_weather?.temperature?.toStringAsFixed(0) ?? ""}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Weather condition
                    Text(
                      _weather?.weatherCondition ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
// In your build method, use the method to display the Nepali date and time
Column(
  children: [
    // Other weather information widgets...
    const SizedBox(height: 16),
    Text(
      getCurrentNepaliDateTime(),
      style: TextStyle(fontSize: 16),
    ),
  ],
),
              // Forecast
              // if (_forecast != null)
              //   ListView.builder(
              //     itemCount: _forecast!.length,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       final weather = _forecast![index];
              //       final dateTime = DateTime.fromMillisecondsSinceEpoch(
              //           weather.dateTime! *
              //               1000); // Convert seconds to milliseconds
              //       final dayOfWeek = DateFormat('EEEE').format(dateTime);
              //       return ListTile(
              //         title: Text(dayOfWeek),
              //         subtitle: Text(weather.weatherCondition),
              //         trailing: Text(
              //             '${weather.temperature?.toStringAsFixed(0) ?? ""}°C'),
              //       );
              //     },
              //   )
              // else
              //   const SizedBox(
              //     height: 200,
              //     child: Center(
              //       child: CircularProgressIndicator(),
              //     ),
              //   ),
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
        currentTime >
            sunset; // It's night time if current time is before sunrise or after sunset
  }
}
