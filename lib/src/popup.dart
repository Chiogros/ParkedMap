import 'package:flutter/material.dart';
import 'package:parkedmap/src/place.dart';
import 'package:parkedmap/src/place_marker.dart';
import 'package:url_launcher/url_launcher.dart';

class Popup extends StatefulWidget {
  final PlaceMarker _placeMarker;

  const Popup(this._placeMarker, {Key? key}) : super(key: key);

  @override
  _PopupState createState() => _PopupState(_placeMarker, _placeMarker.getPlace());
}

class _PopupState extends State<Popup> {
  final PlaceMarker _marker;
  final Place _place;

  _PopupState(this._marker, this._place);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(

          children: <Widget>[
            IconButton(
                onPressed: () async {
                  await launch("https://www.google.com/maps/search/?api=1&query=${_place.getLocation().latitude},${_place.getLocation().longitude}");
                },
                icon: const Icon(Icons.alt_route)
            ),
            Text(_place.getDifficulty().toString())
          ],
        )
      )
    );
  }
}