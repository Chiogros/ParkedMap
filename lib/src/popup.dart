import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:parkedmap/src/place.dart';
import 'package:parkedmap/src/place_marker.dart';
import 'package:url_launcher/url_launcher.dart';

class Popup extends StatefulWidget {
  final PlaceMarker placeMarker;

  const Popup({
    Key? key,
    required this.placeMarker
  }) : super(key: key);

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  late final Place _place = widget.placeMarker.getPlace();

  // Contains place attributes's strings to display
  HashMap<String, String> strings = HashMap();

  _PopupState();

  void setAttributes() {
    // Set text for difficulty
    switch(_place.getDifficulty()) {
      case PlaceDifficulty.easy: strings["difficulty"] = "Easy"; break;
      case PlaceDifficulty.medium: strings["difficulty"] = "Medium"; break;
      case PlaceDifficulty.hard: strings["difficulty"] = "Hard"; break;
    }

    // Set text for type
    switch(_place.getType()) {
      case PlaceType.deg0: strings["type"] = "0 degree"; break;
      case PlaceType.deg45: strings["type"] = "45 degrees"; break;
      case PlaceType.deg90: strings["type"] = "90 degrees"; break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                onPressed: () async {
                  setAttributes();
                  await launch("https://www.google.com/maps/search/?api=1&query=${_place.getLocation().latitude},${_place.getLocation().longitude}");
                },
                icon: const Icon(Icons.alt_route)
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(strings["difficulty"]),
                Text(strings["type"]),
              ],
            )
          ],
        )
      )
    );
  }
}