import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:parkedmap/src/place.dart';

class PlaceMarker extends Marker {
  final Place _place;

  PlaceMarker(this._place) : super(
    point: _place.getLocation(),
    builder: (_) {
      Icon icon2display;
      switch (_place.getType()) {
        case PlaceType.deg0:
          icon2display = const Icon(
            Icons.location_on,
            size: 40,
            color: Color(0xFF33AA33)
          );
          break;
        case PlaceType.deg45:
          icon2display = const Icon(
              Icons.location_on,
              size: 40,
              color: Color(0xFFAA3333)
          );
          break;
        case PlaceType.deg90:
          icon2display = const Icon(
              Icons.location_on,
              size: 40,
              color: Color(0xFF3333AA)
          );
          break;
      }
      return icon2display;
    }
  );

  Place getPlace() {
    return _place;
  }
}