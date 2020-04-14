import '../storage/app_constants.dart';
import 'package:flutter/material.dart';
import '../services/localization.dart';

//User Profile Screen
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ConcordiaLocalizations.of(context).profile,
        ),
        backgroundColor: appColor,
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            ConcordiaLocalizations.of(context).profile,
          ),
          color: appColor,
          textColor: whiteColor,
          onPressed: () {
            showDialog(
                context: context,
                child: new AlertDialog(
                  title: new Text(
                    ConcordiaLocalizations.of(context).profile,
                  ),
                  content: new Text("Coming Soon!"),
                ));
          },
        ),
      ),
    );
  }
}
