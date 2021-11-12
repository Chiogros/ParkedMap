import 'package:flutter/material.dart';
import 'map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ParkedMap",
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ParkedMap"),
          backgroundColor: const Color(0xFF00AA33),
        ),
        body: const CustomMap(),
      ),
    );
  }
}
