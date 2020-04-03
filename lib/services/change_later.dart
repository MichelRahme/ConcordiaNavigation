import 'package:concordia_navigation/models/building.dart';
import 'package:concordia_navigation/models/classroom.dart';
import 'package:concordia_navigation/models/coordinate.dart';
import 'package:concordia_navigation/models/floor.dart';
import 'package:concordia_navigation/models/indoor_interest.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class LoadBuildingInfo {
  static Set<Building> buildingSet = Set<Building>();
  static Set<Floor> floorSet = Set<Floor>();
  static Set<Classroom> classroomSet = Set<Classroom>();
  static Set<IndoorInterest> indoorInterestSet = Set<IndoorInterest>();
  static List<Coordinate> roomCoordinates = new List<Coordinate>();
  static List<Coordinate> nearestCoordinates = new List<Coordinate>();
  static List<double> xRoomList = new List<double>();
  static List<double> yRoomList = new List<double>();
  static List<double> xNearList = new List<double>();
  static List<double> yNearList = new List<double>();
  static List trip = [];

  LoadBuildingInfo() {
    _readFile();
  }

  static Future getClassroomSet() async {
    return classroomSet;
  }

//-------class methods----------------------
  ///For reading the file
  Future<Map> _loadAsset() async {
    return await json
        .decode(await rootBundle.loadString('assets/buildings_indoor.json'));
  }

  ///Send String value to be organized
  void _readFile() async {
    Future<Map> future = _loadAsset();
    future.then((data) {
      _organizeToSet(data);
      setXList();
    });
  }

  ///THIS IS BEING CALLED MULTIPLE TIMES!
  ///Parse String into elements and add to list
  void _organizeToSet(Map data) {
    for (int i = 0; i < data['buildings'].length; i++) {
      for (int j = 0; j < data['buildings'][i]['floors'].length; j++) {
        for (int k = 0;
            k < data['buildings'][i]['floors'][j]['classrooms'].length;
            k++) {
          classroomSet.add(
            Classroom(
              classroomNumber: int.parse(
                  data['buildings'][i]['floors'][j]['classrooms'][k]['number']),
              classroomCoordinates: Coordinate(
                x: double.parse(
                  data['buildings'][i]['floors'][j]['classrooms'][k]
                      ['coordinates'][0]['classroom']['x'],
                ),
                y: double.parse(
                  data['buildings'][i]['floors'][j]['classrooms'][k]
                      ['coordinates'][0]['classroom']['y'],
                ),
              ),
              nearestCoordinates: Coordinate(
                x: double.parse(
                  data['buildings'][i]['floors'][j]['classrooms'][k]
                      ['coordinates'][0]['nearest']['x'],
                ),
                y: double.parse(
                  data['buildings'][i]['floors'][j]['classrooms'][k]
                      ['coordinates'][0]['nearest']['y'],
                ),
              ),
            ),
          );
        }
        for (int k = 0;
            k < data['buildings'][i]['floors'][j]['poi'].length;
            k++) {
          indoorInterestSet.add(
            IndoorInterest(
              name: data['buildings'][i]['floors'][j]['poi'][k]['name'],
              roomCoordinates: Coordinate(
                x: double.parse(
                  data['buildings'][i]['floors'][j]['poi'][k]['coordinates'][0]
                      ['room']['x'],
                ),
                y: double.parse(
                  data['buildings'][i]['floors'][j]['poi'][k]['coordinates'][0]
                      ['room']['y'],
                ),
              ),
              nearestCoordinates: Coordinate(
                x: double.parse(
                  data['buildings'][i]['floors'][j]['poi'][k]['coordinates'][0]
                      ['nearest']['x'],
                ),
                y: double.parse(
                  data['buildings'][i]['floors'][j]['poi'][k]['coordinates'][0]
                      ['nearest']['y'],
                ),
              ),
            ),
          );
        }
        floorSet.add(
          Floor(
            floorNumber: int.parse(
              data['buildings'][i]['floors'][j]['number'],
            ),
            classrooms: classroomSet,
          ),
        );
        buildingSet.add(
          Building(
            buildingInitial: data['buildings'][i]['initial'],
            floors: floorSet,
          ),
        );
      }
    }
  }

  void setXList() {
    for (int i = 0; i < trip.length; i++) {
      if (trip[i] is String) {
        roomCoordinates.add(indoorInterestSet
            .firstWhere((room) => room.name == trip[i])
            .roomCoordinates);
        nearestCoordinates.add(indoorInterestSet
            .firstWhere((room) => room.name == trip[i])
            .nearestCoordinates);
      } else {
        roomCoordinates.add(classroomSet
            .firstWhere((classroom) => classroom.classroomNumber == trip[i])
            .classroomCoordinates);
        nearestCoordinates.add(classroomSet
            .firstWhere((classroom) => classroom.classroomNumber == trip[i])
            .nearestCoordinates);
      }
    }
    for (int i = 0; i < roomCoordinates.length; i++) {
      xRoomList.add(roomCoordinates[i].x);
      yRoomList.add(roomCoordinates[i].y);
    }

    for (int i = 0; i < nearestCoordinates.length; i++) {
      xNearList.add(nearestCoordinates[i].x);
      yNearList.add(nearestCoordinates[i].y);
    }
  }
}