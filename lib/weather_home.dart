import 'dart:convert';
import 'package:aankhijhyal/User/user_profile.dart';
import 'package:aankhijhyal/location_search.dart';
import 'package:aankhijhyal/models/weather_model.dart';
import 'package:aankhijhyal/posts/featured_post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

//weather home page
//need more improvements in home page T_T
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
  DateTime? _lastRefreshTime; // Track the last refresh time
  bool _isRefreshing = false;

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

    NepaliDateFormat displayFormat = NepaliDateFormat('MMMM d, yyyy G.');

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
    if (_isRefreshing) return; // Prevent multiple refreshes
    if (_lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) <
            const Duration(seconds: 10)) {
      // If the last refresh was less than 10 seconds ago, display a message and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait a few seconds before refreshing again'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isRefreshing = true;
    });

    await _fetchWeather();

    setState(() {
      _isRefreshing = false;
      _lastRefreshTime = DateTime.now(); // Update the last refresh time
    });

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 15),
                InkWell(
                  onTap: _chooseLocation,
                  child: SvgPicture.asset(
                    'assets/images/location.svg',
                    width: 24,
                    height: 24,
                    color: const Color(0xFF00A1F2),
                    //  color: const Color(0xFF9c9c9c),
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
                              // : const Color(0xFF00A1F2),
                              : const Color(0xFF646464),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const UserProfile(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(
                              1.0, 0.0); // Slide from right to left
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    color: Color(0xFF00A1F2),
                    //  color: Color(0xFF9c9c9c),
                  ),
                ),
                const SizedBox(width: 15),
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
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                      "${(_weather?.cityName ?? "")} is feeling ${(_weather?.weatherCondition ?? "")}.",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9c9c9c),
                      ),
                    ),
                    //  const SizedBox(height: 5),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment(
                              0.0, 1.2), // Start slightly below the center
                          end: Alignment.topCenter,
                          colors: [Color(0xFF0C5980), Color(0xFF9c9c9c)],
                          stops: [0.0, 1.0],
                        ).createShader(bounds);
                      },
                      child: Text(
                        '${_weather?.temperature?.toStringAsFixed(0) ?? ""}°C',
                        style: const TextStyle(
                          fontSize: 85,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .white, // Text color doesn't matter here, as it will be masked
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0), // To add padding to right
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/princess style.png', // image path
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              const Divider(
                color: Color(0xFFF2F2F2), // Change divider color to white just reference for replacement
                thickness: 1.5,
                height: 0,
                indent: 16,
                endIndent: 16,
              ),

              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Aajko Vishestha',
                            style: TextStyle(
                              //color:Color(0xFF0C5980), // Use #00dc64 color (0xFFFFBF00)
                              color: Color(0xFF7C7C7C),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              getCurrentNepaliDateTime(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF7C7C7C), //
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Color(0xFFF2F2F2), // Change divider color to white
                      thickness: 1.5,
                      height: 0,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeaturedPostPage(
                              title:
                                  'Viral video falsely claims elephants sent from Nepal to Qatar.',
                              description:
                                  'A video of an elephant riding a truck is going viral on social media recently. In the video, the elephant is seen leaning on a tool and climbing onto the trolley of the truck. Many social media users are sharing this video saying that this is the elephant that is going to be sent from Nepal to Qatar. However, it is not true. Misinformation is being spread on social media that the Emir of Qatar, Sheikh Tamim bin Hamad Al Thani, who came to Kathmandu on Tuesday, returned home on Wednesday and an elephant was also sent along with him. Many social media users are sharing this video saying that this is the elephant that is going to be sent from Nepal to Qatar. However, it is not true. Misinformation is being spread on social media that the Emir of Qatar, Sheikh Tamim bin Hamad Al Thani, who came to Kathmandu on Tuesday, returned home on Wednesday and an elephant was also sent along with him. Many social media users are sharing this video saying that this is the elephant that is going to be sent from Nepal to Qatar. However, it is not true. Misinformation is being spread on social media that the Emir of Qatar, Sheikh Tamim bin Hamad Al Thani, who came to Kathmandu on Tuesday, returned home on Wednesday and an elephant was also sent along with him. Many social media users are sharing this video saying that this is the elephant that is going to be sent from Nepal to Qatar. However, it is not true. Misinformation is being spread on social media that the Emir of Qatar, Sheikh Tamim bin Hamad Al Thani, who came to Kathmandu on Tuesday, returned home on Wednesday and an elephant was also sent along with him. Many social media users are sharing this video saying that this is the elephant that is going to be sent from Nepal to Qatar. However, it is not true. Misinformation is being spread on social media that the Emir of Qatar, Sheikh Tamim bin Hamad Al Thani, who came to Kathmandu on Tuesday, returned home on Wednesday and an elephant was also sent along with him.',
                              imageUrl:
                                  'https://scontent.fktm7-1.fna.fbcdn.net/v/t39.30808-6/438224087_792497989494984_8452363610187508156_n.jpg?_nc_cat=105&_nc_cb=99be929b-713f6db7&ccb=1-7&_nc_sid=5f2048&_nc_ohc=tjhi3YtuuBgQ7kNvgF-7oPl&_nc_ht=scontent.fktm7-1.fna&oh=00_AfDmgyklZ89MJQtX_ODHdm6af0SMPo1j_YAwITrD3BXiiA&oe=662FF5EF',
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Viral video falsely claims elephants sent from Nepal to Qatar...',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0C5980),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image//asuka
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Center(
                                    child: Image.network(
                                      'https://scontent.fktm7-1.fna.fbcdn.net/v/t39.30808-6/438224087_792497989494984_8452363610187508156_n.jpg?_nc_cat=105&_nc_cb=99be929b-713f6db7&ccb=1-7&_nc_sid=5f2048&_nc_ohc=tjhi3YtuuBgQ7kNvgF-7oPl&_nc_ht=scontent.fktm7-1.fna&oh=00_AfDmgyklZ89MJQtX_ODHdm6af0SMPo1j_YAwITrD3BXiiA&oe=662FF5EF',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Title and body
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'A video of an elephant riding a truck is going viral on social media recently. In the video, the elephant is seen leaning on a tool and climbing onto the trolley of the truck. Many social media users are sharing this video saying that this is the elephant that is going to be sent from Nepal to Qatar. However, it is not true. Misinformation is being spread on social media that the Emir of Qatar, Sheikh Tamim bin Hamad Al Thani, who came to Kathmandu on Tuesday, returned home on Wednesday and an elephant was also sent along with him.',
                                        style: TextStyle(
                                          color: Color(0xFF7C7C7C),
                                          fontSize: 13,
                                          fontStyle: FontStyle
                                              .italic, // Add italic font style
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Read more...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0C5980),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
