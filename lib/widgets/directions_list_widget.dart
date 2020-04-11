import 'package:concordia_navigation/providers/map_data.dart';
import 'package:concordia_navigation/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:concordia_navigation/storage/app_constants.dart' as constants;

class DirectionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapData>(
      builder: (context, mapData, child) => mapData.itinerary == null
          ? Container(
              height: SizeConfig.safeBlockVertical * 46,
              color: constants.whiteColor,
              child: Center(
                child: Text(
                  "Choose Start and End Locations",
                  style: GoogleFonts.raleway(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: constants.blackColor,
                  ),
                ),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: mapData.itinerary.itinerary.length,
                itemBuilder: (context, index) {
                  String key =
                      mapData.itinerary.itinerary.keys.elementAt(index);
                  return Container(
                    decoration: BoxDecoration(
                      color: constants.whiteColor,
                      border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: constants.lightGreyColor),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                          left: SizeConfig.safeBlockHorizontal * 5.0,
                          right: SizeConfig.safeBlockHorizontal * 5.0),
                      leading: Icon(Icons.subdirectory_arrow_right),
                      title: Text(
                        "$key",
                        style: GoogleFonts.raleway(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: constants.blackColor,
                        ),
                      ),
                      subtitle: Text(
                        "Time: " +
                            "${mapData.itinerary.itinerary[key].keys.toString().replaceAll(RegExp(r"\(|\)"), "")}" +
                            "  " +
                            "Distance: " +
                            "${mapData.itinerary.itinerary[key].values.toString().replaceAll(RegExp(r"\(|\)"), "")}",
                        style: GoogleFonts.raleway(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: constants.blackColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}