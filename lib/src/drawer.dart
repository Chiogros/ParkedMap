import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  var logo = "images/car.svg";

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: const <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: const Column(children: [
          const Text(
            "ParkedMap",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain, // otherwise the logo will be tiny
              child: SvgPicture.asset(logo),
            ),
          ),
        ]),
      ),
      ListTile(leading: Icon(Icons.add_location_alt_rounded), title: Text("Follow someone")),
    ]));
  }
}
