import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mywall/signin.dart';
import 'package:mywall/uploadPage.dart';
import 'package:mywall/wall.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return const MaterialApp(
      home: signin(),
    );
  }
}
