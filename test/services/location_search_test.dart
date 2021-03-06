import 'package:concordia_navigation/models/indoor/indoor_location.dart';
import 'package:concordia_navigation/models/outdoor/building.dart';
import 'package:concordia_navigation/models/outdoor/university.dart';
import 'package:concordia_navigation/services/location_search.dart';
import 'package:concordia_navigation/services/outdoor/shuttle_service.dart';
import 'package:concordia_navigation/services/outdoor_poi_list.dart';
import 'package:concordia_navigation/services/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../app_widget.dart';

void main() {
  group('LocationSearch', () {

    setUp( () async {
    ShuttleService.shuttleSchedule = await ShuttleService.loadJson();
    OutdoorPOIList.poi = await OutdoorPOIList.loadJson();

    List<dynamic> data = await University.loadJson();
    University.concordia = University.fromJson(data);

    Search.supported.forEach((object) {
    if (object is IndoorLocation || object is Building)
      Search.names.add(object.name.toUpperCase());
    });
  });
    testWidgets('opens page for searching locations.',
        (WidgetTester tester) async {
      await tester.pumpWidget(appWidget(testWidget: TestSearchDelegate()));

      // Wait for LocalizationsDelegate's futures
      await tester.pumpAndSettle();
      final openLocationSearch = find.byKey(Key("SearchDelegate"));
      await tester.tap(openLocationSearch);

      await tester.pumpAndSettle();

      // Find list of suggested locations
      final icon = find.byIcon(Icons.location_city);
      expect(icon, findsWidgets);

      // Try text field
      final query = find.byType(TextField);
      await tester.enterText(query, "concordia");
      final concordiaText = find.text("concordia");
      expect(concordiaText, findsOneWidget);

      // Try clearing text field
      final clear = find.byIcon(Icons.clear);
      await tester.tap(clear);
      await tester.pumpAndSettle();
      expect(concordiaText, findsNothing);

      // Go back to homepage
      final backBtn = find.byType(AnimatedIcon);
      await tester.tap(backBtn);
      await tester.pumpAndSettle();
      expect(icon, findsNothing);
    });
  });
}

class TestSearchDelegate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        key: Key("SearchDelegate"),
        onPressed: () {
          showSearch(context: context, delegate: LocationSearch(true));
        });
  }
}
