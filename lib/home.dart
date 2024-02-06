import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iti_flutter/app_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () => _loginUser('marwa@gmail.com', '123456789'),
              child: Text('Sign In')),
          ElevatedButton(
              onPressed: () =>
                  _registerNewUser('marwan@gmail.com', '1234'),
              child: Text('Sign Up')),
        ],
      )),
    );
  }

  _loginUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AppScreen(),
        //     ));
        Navigator.pushNamed(context, '/app');
      }
    } on FirebaseAuthException catch (e) {
      print('code: ${e.code}\n message:${e.message}');
    }
  }

  _registerNewUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        Navigator.pushNamed(context, '/app');
      }
    } on FirebaseAuthException catch (e) {
      print('code: ${e.code}\n message:${e.message}');
    }
  }
}
