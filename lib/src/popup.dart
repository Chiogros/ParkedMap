import 'package:flutter/material.dart';
import 'package:parkedmap/src/place_marker.dart';

class Popup extends StatefulWidget {
  final PlaceMarker _placeMarker;

  const Popup(this._placeMarker, {Key? key}) : super(key: key);

  @override
  _PopupState createState() => _PopupState(_placeMarker);
}

class _PopupState extends State<Popup> {
  final PlaceMarker _marker;

  _PopupState(this._marker);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Text("salut")
    );
  }
}