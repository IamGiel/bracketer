import 'package:bracketer/UI/startupForm_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Container(
      decoration: BoxDecoration(
        color: Color(0xff7c94b6),
        image: DecorationImage(
          image: AssetImage("assets/bracketBGImage.png"),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(
          //     Colors.white.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent, body: Container(child: MyApp())),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: StartUpForm(),
        )
      ],
    );
  }
}
