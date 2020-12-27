import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/icon.png",
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
