import 'package:flutter/material.dart';
import 'package:fluttertravelapp/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );

    // return Scaffold(
    //   body: AppBar(
    //     title: const Text('Travel App'),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {},
    //     child: const Icon(Icons.add),
    //   ),
    // );
  }
}
