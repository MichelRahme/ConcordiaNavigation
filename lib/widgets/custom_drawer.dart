import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:concordia_navigation/services/localization.dart';
import 'package:concordia_navigation/models/map_data.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  Widget _expendTile() {
    return Theme(
      data: ThemeData(
        accentColor: Color(0xFF73C700),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.map),
        title: new Text(
          "Campus",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          new Column(
            children: _buildExpandableContent(),
          ),
        ],
      ),
    );
  }

  _buildExpandableContent() {
    List<Widget> columnContent = [];

    columnContent.add(
      Consumer<MapData>(
        builder: (context, mapData, child) {
          return ListTile(
              title: new Text(
                "Sir George Williams",
                style: GoogleFonts.raleway(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                mapData.animateTo(45.496676, -73.578760);
              });
        },
      ),
    );

    columnContent.add(
      Consumer<MapData>(
        builder: (context, mapData, child) {
          return ListTile(
              title: new Text(
                "Loyola",
                style: GoogleFonts.raleway(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                mapData.animateTo(45.4582, -73.6405);
              });
        },
      ),
    );

    return columnContent;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 42.5,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFF8),
            ),
            child: ListTile(
              title: Text(
                "ConNavigator",
                style: GoogleFonts.raleway(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF76C807),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: Container(
              color: Color(0xFFF0F0F0),
              height: 2,
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: _expendTile(),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                ConcordiaLocalizations.of(context).schedule,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/schedule');
              },
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                ConcordiaLocalizations.of(context).interest,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/o_interest');
              },
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                ConcordiaLocalizations.of(context).profile,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                ConcordiaLocalizations.of(context).settings,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            child: Container(
              color: Color(0xFFF0F0F0),
              height: 2,
            ),
          ),
          Container(
            color: Color(0xFFFFFFF8),
            height: 570,
          ),
        ],
      ),
    );
  }
}