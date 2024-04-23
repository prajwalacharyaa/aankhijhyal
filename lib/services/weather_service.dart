import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

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