import 'package:flutter/material.dart';
import 'package:local_storage_sqflite/services/local_storage_sqflite_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    testFunction();
  }

  void testFunction() async {
    await LocalStorageSqfliteService.getDatabasePath();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold());
  }
}
