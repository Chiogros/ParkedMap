import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkedmap/src/place.dart';
import 'package:parkedmap/src/place_marker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String getDifficultyString(BuildContext context) => Intl.select(
    _place.getDifficulty(),
    {
      PlaceDifficulty.easy: AppLocalizations.of(context)!.easy,
      PlaceDifficulty.medium: AppLocalizations.of(context)!.medium,
      PlaceDifficulty.hard: AppLocalizations.of(context)!.hard,
    }
  );

  String getTypeString(BuildContext context) => Intl.select(
      _place.getType(),
      {
        PlaceType.deg0: AppLocalizations.of(context)!.deg0,
        PlaceType.deg45: AppLocalizations.of(context)!.deg45,
        PlaceType.deg90: AppLocalizations.of(context)!.deg90,
      }
  );

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
                  await launch("https://www.google.com/maps/search/?api=1&query=${_place.getLocation().latitude},${_place.getLocation().longitude}");
                },
                icon: const Icon(Icons.alt_route)
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(getDifficultyString(context)),
                Text(getTypeString(context)),
              ],
            )
          ],
        )
      )
    );
  }
}