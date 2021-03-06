import '../../providers/indoor_data.dart';
import '../../services/indoor/painter_service.dart';
import '../../services/indoor/painters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_widget/zoom_widget.dart';
import '../../storage/app_constants.dart' as constants;

/// Widget which shows indoor map and on-map directions
class IndoorWidget extends StatelessWidget {
  final int index;
  IndoorWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Zoom(
        initZoom: 0.0,
        zoomSensibility: 2.3,
        scrollWeight: 10.0,
        centerOnScale: true,
        backgroundColor: constants.whiteColor,
        canvasColor: constants.whiteColor,
        doubleTapZoom: false,
        enableScroll: true,
        opacityScrollBars: 0,
        width: 940,
        height: 862,
        child: Container(
          child: Stack(
            children: <Widget>[
              Painters.painters[index],
              Provider.of<IndoorData>(context).indoorItinerary != null
                  ? CustomPaint(
                      painter: PainterService(index,
                          Provider.of<IndoorData>(context).indoorItinerary))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
