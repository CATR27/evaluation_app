import 'dart:async';
import 'package:contador_wearable/screens/model.dart';
import 'package:contador_wearable/screens/service.dart';
import 'package:wear/wear.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {
  final WeatherService weatherService;
  final WearMode mode;

  const WeatherWidget(this.mode, {required this.weatherService});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late WeatherData _weatherData;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _weatherData = WeatherData(
      cityName: '',
      temperature: 0,
      description: '',
      iconUrl: '',
    );

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
      _getWeather();
    });
  }

  Future<void> _getWeather() async {
    try {
      final weatherData =
          await widget.weatherService.getWeather('San Juan del Rio');
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.mode == WearMode.active
                  ? Color.fromARGB(220, 255, 136, 0)
                  : const Color.fromARGB(220, 0, 0, 0),
              widget.mode == WearMode.active
                  ? const Color.fromARGB(220, 255, 136, 0)
                  : Color.fromARGB(220, 19, 26, 27),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('d MMMM yyyy').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12, 
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${now.hour}:${now.minute}:${now.second}',
              style: const TextStyle(fontSize: 26, color: Colors.white), 
            ),
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _weatherData.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _weatherData.cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_weatherData.temperature}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
