import 'dart:typed_data';

import 'package:concordia_navigation/models/outdoor/building.dart';
import 'package:concordia_navigation/services/search.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

///Observer Pattern
///Handles data related to campus buildings, listens to changes and notifies listeners.
class BuildingsData extends ChangeNotifier {
  static List<Building> allBuildings = [];
  List<Polygon> _allPolygons = [];
  List<Polygon> _clear = [];

  bool _visible = true;

  List<Polygon> get allPolygons {
    if (_visible) {
      return _allPolygons;
    }
    return _clear;
  }

  BuildingsData() {
    // Make one big set of buildings that has sgw + loy buildings
    allBuildings = Search.supported.whereType<Building>().toList();

    // Add the outline of every buildings to one big set of Polygons
    allBuildings.forEach((building) {
      _allPolygons.add(building.outline);

      getBytesFromAsset(building.logo, 350).then((uint8list) {
        Building.icons[building] = BitmapDescriptor.fromBytes(uint8list);
      });
    });

    _visible = true;
  }

  void toggleOutline() {
    _visible = !_visible;
    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
