import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds:HomePage() ,
      title: Text("Fruits Recognation App" ,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.lightBlueAccent),
      ),
      image: Image.asset('assets/fruits.png'),
      backgroundColor: Colors.white70,
      photoSize: 180,
      loaderColor: Colors.blueAccent,
      loadingText: Text("Loding",style: TextStyle(fontSize: 18,color: Colors.blueAccent),),
    );
  }
}


