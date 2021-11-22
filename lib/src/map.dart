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
  LatLng position = LatLng(48.8582615, 2.2927286);
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

  Future<JsonDecoder> downloadPlaces() async {
    const String url = "https://gist.github.com/Chiogros/c9b97d6d1263a2baad29b3203eda7afb/raw/dc7c0354b258741078217f14415325a433d3194c/parking.json";

    Response response = await get(Uri.parse(url));
    JsonDecoder data = jsonDecode(response.body);

    return data;
  }

  Future<List<LatLng>> parsePlaces(JsonDecoder _data) async {
    List<LatLng> _places = <LatLng>[];

    (_data as List).map((e) {
      _places.add(LatLng(e["lat"], e["lng"]));
    });

    return _places;
  }
  
  void updatePlaces() async {
    _markerPositions = await parsePlaces(
      await downloadPlaces()
    );

    setState(() {});
    
    return ;
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
