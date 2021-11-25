import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';  // getCurrentPosition()
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';  //
import 'package:flutter_map/flutter_map.dart';  // FlutterMap
import 'package:latlong2/latlong.dart'; // LatLng
import 'package:http/http.dart';  // get(Uri)
import 'package:parkedmap/src/place.dart';
import 'package:parkedmap/src/place_marker.dart';

import 'popup.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({Key? key}) : super(key: key);

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  LatLng _position = LatLng(45.172044, 5.734129);
  final PopupController _popupLayerController = PopupController();
  List<Place> _places = <Place>[];

  Future<String> _downloadPlaces() async {
    const String _url = "https://gist.github.com/Chiogros/c9b97d6d1263a2baad29b3203eda7afb/raw/d389ade685958301e84ac18ab8a916cf779d2da9/parking.json";

    Response _response = await get(Uri.parse(_url));

    if (_response.statusCode != 200) {
      throw Exception("Cannot download places list.");
    }

    return _response.body;
  }

  List<dynamic> _parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } on FormatException {
      throw const FormatException("Parsing error.");
    }
  }

  Future<List<Place>> _parsePlaces(List<dynamic> _data) async {
    List<Place> _places = <Place>[];

    // Transform all json places in Place objects
    _data.map((e) {
      LatLng _location;
      PlaceType _type;
      PlaceDifficulty _difficulty;

      if (!(e["lat"] is double
         && e["lng"] is double
         && e["type"] is String
         && e["difficulty"] is String)) {
        throw const FormatException("A parameter is wrong.");
      }

      // Check type and difficulty are non empty
      if (e["type"].toString().isEmpty
       || e["difficulty"].toString().isEmpty) {
        throw const FormatException("A type or a difficulty is empty.");
      }

      // Set location
      _location = LatLng(e["lat"], e["lng"]);

      // Set type
      switch(e["type"]) {
        case "deg0":
          _type = PlaceType.deg0;
          break;
        case "deg45":
          _type = PlaceType.deg45;
          break;
        case "deg90":
          _type = PlaceType.deg90;
          break;
        default:
          throw FormatException("'" + e["type"] + "' is not a valid type.");
      }

      // Set difficulty
      switch(e["difficulty"]) {
        case "easy":
          _difficulty = PlaceDifficulty.easy;
          break;
        case "medium":
          _difficulty = PlaceDifficulty.medium;
          break;
        case "hard":
          _difficulty = PlaceDifficulty.hard;
          break;
        default:
          throw FormatException("'" + e["difficulty"] + "' is not a valid difficulty.");
      }

      // Add generated Place object to list
      _places.add(Place(
        _location,
        _type,
        _difficulty
      )); // _places.add
    }).toList();  // map

    return _places;
  }
  
  void _updatePlaces() async {
    try {
      String _rawData = await _downloadPlaces();
      List<dynamic> _data = _parseJson(_rawData);

      _places = await _parsePlaces(_data);
    } on FormatException catch (fex) {
      // SnackBar
      SnackBar(
        content: Text(fex.message)
      );
    } on Exception catch (ex) {
      //SnackBar
      SnackBar(
          content: Text(ex.toString())
      );
    }

    // Refresh display
    setState(() {});
  }

  List<PlaceMarker> _getMarkersFromPlaces(List<Place> _places2transform) {
    return _places2transform.map((p) => PlaceMarker(p)).toList();
  }
  
  void _onButton() async {
    try {
      // Center view on current position
      Position currentPos = await Geolocator.getCurrentPosition();
      _position = LatLng(
          currentPos.latitude,
          currentPos.longitude
      );
    } on TimeoutException {
      // nothing
    } on PermissionDeniedException {
      await GeolocatorPlatform.instance.requestPermission();
    } on LocationServiceDisabledException {
      SnackBar(
        action: SnackBarAction(
          label: "Settings",
          onPressed: _openLocSettings,
        ),
        content: const Text("Location disabled"),
      );
    }
  }

  void _openLocSettings() async {
    await GeolocatorPlatform.instance.openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.local_parking),
        title: const Text("ParkedMap"),
        backgroundColor: const Color(0xFF00AA33),
        actions: [
          IconButton(
            onPressed: _updatePlaces,
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _position,
          zoom: 13.0,
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            )
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              popupController: _popupLayerController,
              markers: _getMarkersFromPlaces(_places),
              markerRotateAlignment: PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
              popupBuilder: _popUpWidget,
              markerCenterAnimation: const MarkerCenterAnimation(), // Center view on marker when clicked
              popupAnimation: const PopupAnimation.fade(
                duration: Duration(
                  milliseconds: 200
                )
              ) // PopUp fade I/O animation
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onButton,
        child: const Icon(Icons.my_location),
        backgroundColor: const Color(0xFF00AA33),
      ),
    );
  }

  Widget _popUpWidget(BuildContext context, dynamic marker) => Popup(placeMarker: marker);  // for popup builder
}
