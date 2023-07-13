import 'dart:async';
import 'package:barikoi_maplibre_map/utils/const.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Map');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 80, height: 80,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                      text: 'Bari',
                      style: TextStyle(
                          color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(text: 'Koi',
                            style: TextStyle(
                                color: primaryColor, fontSize: 36, fontWeight: FontWeight.bold),
                        )
                      ]
                  ),
                ),
                Text("Location Data Provider".toUpperCase(), style: TextStyle(fontSize: 10, letterSpacing: 1.5),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}