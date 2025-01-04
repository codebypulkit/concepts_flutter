import 'package:flutter/material.dart';
import 'package:concepts_bloc/pages/weather_search_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: WeatherSearchPage());
  }
}
