import 'dart:async';
import 'floating_map_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:concordia_navigation/models/user_location.dart';
import 'package:concordia_navigation/providers/buildings_data.dart';
import 'package:concordia_navigation/providers/map_data.dart';
import 'package:concordia_navigation/services/size_config.dart';
import 'package:concordia_navigation/services/location_service.dart';
import 'package:concordia_navigation/widgets/floating_map_button.dart';
import 'package:provider/provider.dart';
import 'package:concordia_navigation/storage/app_constants.dart' as constants;
import 'package:concordia_navigation/widgets/building_widgets/building_marker.dart';
import 'package:concordia_navigation/models/buildingModels/building_list.dart';
import 'package:concordia_navigation/models/buildingModels/building_information.dart';

//This is the map widget that will be loaded in the home screen.
class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  CameraPosition _initialCamera;
  bool _campus = true;
  var _location;

  BuildingList buildingList = BuildingList();
  List<BuildingInformation> buildings;
  Set<Marker> setOfMarkers = {};

  Future setInitialCamera() async {
    var location = UserLocation.fromLocationData(
        await LocationService.getInstance().getLocationData());
    _initialCamera = CameraPosition(
      target: location.toLatLng(),
      zoom: constants.CAMERA_ZOOM,
      tilt: constants.CAMERA_TILT,
      bearing: constants.CAMERA_BEARING,
    );
    return location;
  }

  @override
  void initState() {
    super.initState();
    Future location = setInitialCamera();
    location.then((value) => _location = value);
    SizeConfig();
    buildings = buildingList.getListOfBuildings();
  }

  @override
  Widget build(BuildContext context) {
    if (_location != null) {
      Provider.of<MapData>(
        context,
        listen: false,
      ).changeCurrentLocation(_location.toLatLng());
    }
    SizeConfig().init(context);
    final _completer = Provider.of<MapData>(context).getCompleter;
    final _buildings = Provider.of<BuildingsData>(context);
    final pos = Provider.of<UserLocation>(context);

    while (_initialCamera == null) {
      return Center(child: Text("Loading Map"));
    }

    ///Create markers here
    if (buildings.length <= 58) {
      buildingList.readBuildingFile();
      while (buildings.length == 0) {
        return Container(
          width: 0,
          height: 0,
        );
      }
      for (int i = 0; i < 58; i++) {
        BuildingMarker buildingMarker =
            BuildingMarker(building: buildings.elementAt(i), bContext: context);
        setOfMarkers.add(buildingMarker.getMarker());
      }
    }

    return Stack(
      children: <Widget>[
        GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            tiltGesturesEnabled: true,
            buildingsEnabled: false,
            mapType: MapType.normal,
            polygons: _buildings.polygons,
            markers: Set.of(setOfMarkers),
            indoorViewEnabled: false,
            trafficEnabled: false,
            initialCameraPosition: _initialCamera,
            polylines:
                Provider.of<MapData>(context).itinerary?.polylines?.toSet(),
            onMapCreated: (controller) async {
              _completer.complete(controller);
            }),
        FloatingMapButton(
          top: SizeConfig.safeBlockVertical * 62,
          left: SizeConfig.safeBlockHorizontal * 83,
          icon: Icon(Icons.swap_calls),
          onClick: () {
            _campus
                ? () {
                    Provider.of<MapData>(context, listen: false).animateTo(
                        constants.sgw.latitude, constants.sgw.longitude);
                    _campus = false;
                  }()
                : () {
                    Provider.of<MapData>(context, listen: false).animateTo(
                        constants.loyola.latitude, constants.loyola.longitude);
                    _campus = true;
                  }();
          },
        ),
        FloatingMapButton(
          top: SizeConfig.safeBlockVertical * 70,
          left: SizeConfig.safeBlockHorizontal * 83,
          icon: Icon(Icons.gps_fixed),
          onClick: () {
            Provider.of<MapData>(context, listen: false)
                .animateTo(pos.latitude, pos.longitude);
          },
        ),
      ],
    );
  }
}
