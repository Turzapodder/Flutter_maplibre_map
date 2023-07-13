import 'package:flutter/material.dart';
import 'package:barikoi_maplibre_map/screens/map_screen.dart';
import 'package:barikoi_maplibre_map/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Map': (BuildContext context) => const MapPage2()
      },
    );
  }
}

