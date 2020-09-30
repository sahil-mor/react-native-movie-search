import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final String route = 'wrapper';
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4))
        .then((value) => Navigator.pushReplacementNamed(context, route));
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/new.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Positioned.fill(
            child: Opacity(
              opacity: .5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff182ac2), Color(0xff98a2b3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror,
                      stops: [.5, 6]),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(flex: 2, child: SizedBox()),
                  Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                    size: 100.0,
                  ),
                  Text(
                    'Smart Lights',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    'By xMetadorz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
