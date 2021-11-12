import 'package:flutter/material.dart';
import 'src/home.dart';

void main() => runApp(const ParkedMap());

class ParkedMap extends StatelessWidget {
  const ParkedMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}