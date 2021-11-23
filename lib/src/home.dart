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
    return const MaterialApp(
      title: "ParkedMap",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomMap(),
      ),
    );
  }
}
