import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';

import 'popup.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({Key? key}) : super(key: key);

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  LatLng position = LatLng(45.172044, 5.734129);
  final PopupController _popupLayerController = PopupController();
  List<LatLng> _markerPositions = [
    LatLng(48.873848, 2.2950682),  // Arc de Triomphe
    LatLng(48.856529, 2.3127059),  // Hôtel des Invalides
    LatLng(48.8719697, 2.3316014),  // Palais Garnier
    LatLng(48.8606111, 2.337644),  // Musée du Louvre
    LatLng(48.8529682, 2.3499021),  // Cathédrale Notre-Dame de Paris
    LatLng(48.8462218, 2.3464138),  // Panthéon
    LatLng(48.8583701, 2.2944813),  // Tour Eiffel
    LatLng(48.8656331, 2.3212357), // Place de la Concorde
  ];

  Future<String> _downloadPlaces() async {
    const String _url = "https://gi.githubusercontent.com/Chiogros/c9b97d6d1263a2baad29b3203eda7afb/raw/bf9b3c4260ba8944cf6b302ff7fdba8d13722122/parking.json";

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

  Future<List<LatLng>> _parsePlaces(List<dynamic> _data) async {
    List<LatLng> _places = <LatLng>[];

    _data.map((e) {
      _places.add(LatLng(e["lat"], e["lng"]));
    }).toList();

    return _places;
  }
  
  void _updatePlaces() async {
    try {
      String _rawData = await _downloadPlaces();
      List<dynamic> _data = _parseJson(_rawData);

      _markerPositions = await _parsePlaces(_data);
    } on FormatException catch (e) {
      // SnackBar
    } on Exception catch (e) {
      //SnackBar
    }

    // Refresh display
    setState(() {});
  }

  void _onButton() async {
    try {
      // Center view on current position
      Position currentPos = await Geolocator.getCurrentPosition();
      position = LatLng(
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
          center: position,
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
              markers: _markers,
              markerRotateAlignment: PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
              popupBuilder: (BuildContext context, Marker marker) =>
                  Popup(marker),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onButton,
        child: const Icon(Icons.my_location),
        backgroundColor: const Color(0xFF00AA33),
      ),
    );
  }

  List<Marker> get _markers => _markerPositions
    .map(
      (markerPosition) => Marker(
        point: markerPosition,
        width: 40,
        height: 40,
        builder: (_) => const Icon(Icons.location_on, size: 40, color: Color(0xFF00AA33)),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      ),
    )
    .toList();
}
