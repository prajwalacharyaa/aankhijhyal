// import 'dart:convert';
// import 'package:aankhijhyal/models/weather_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class WeatherService {
//   static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
//   final String apiKey;

//   WeatherService(this.apiKey);

//   Future<Weather> getWeather(String cityName) async {
//     if (cityName.isEmpty) {
//       // Use Kathmandu as default city
//       cityName = 'Kathmandu';
//     }

//     final response = await http.get(Uri.parse(
//         '$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

//     if (response.statusCode == 200) {
//       return Weather.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load weather data');
//     }
//   }

//   Future<String> getCurrentCity() async {
//     // Get current location
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude, position.longitude);

//     String? city = placemarks[0].locality;

//     return city ?? "";
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

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
  
//for daily forecasts
  // Future<List<Weather>> getForecast(double latitude, double longitude) async {
  //   final response = await http.get(Uri.parse(
  //       '$BASE_URL/onecall?lat=$latitude&lon=$longitude&exclude=current,minutely,hourly&appid=$apiKey&units=metric'));

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     final List<dynamic> dailyForecasts = jsonData['daily'];
  //     return dailyForecasts
  //         .map((forecast) => Weather.fromJson(forecast))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load forecast data');
  //   }
  // }
}
