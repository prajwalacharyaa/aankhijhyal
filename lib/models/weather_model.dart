class Weather {
  final String cityName;
  final String weatherCondition;
  final double? temperature;
  final int? sunrise;
  final int? sunset;
  final int? dateTime; // Add dateTime property

  Weather({
    required this.cityName,
    required this.weatherCondition,
    required this.temperature,
    required this.sunrise,
    required this.sunset,
    required this.dateTime, // Initialize dateTime in the constructor
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      weatherCondition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      dateTime: json['dt'], // Assign value to dateTime from the 'dt' field in the JSON data
    );
  }
}
