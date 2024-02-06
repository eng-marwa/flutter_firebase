import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iti_flutter/home.dart';

import 'app_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    Timer(Duration(seconds: 3), () {
      if (_auth.currentUser != null) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AppScreen(),
        //     ));
        Navigator.pushNamed(context, '/app');
      } else {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MyHomePage(),
        //     ));
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
