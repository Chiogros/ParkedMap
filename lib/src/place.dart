import 'package:latlong2/latlong.dart';

enum PlaceType {
  deg0,  //   -----
  deg45, //   \\\\\
  deg90  //   |||||
}

enum PlaceDifficulty {
  easy,
  medium,
  hard
}

class Place {
  final LatLng _location;
  final PlaceType _type;
  final PlaceDifficulty _difficulty;

  Place(
    LatLng location,
    PlaceType type,
    PlaceDifficulty difficulty
  ) :
    _location = location,
    _type = type,
    _difficulty = difficulty;

  LatLng getLocation() {
    return _location;
  }

  PlaceType getType() {
    return _type;
  }

  PlaceDifficulty getDifficulty() {
    return _difficulty;
  }
}