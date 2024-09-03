import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:jdx/Utils/constants.dart';
import 'package:jdx/services/session.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackLocationScreen extends StatefulWidget {
  const TrackLocationScreen({Key? key, this.driverLatLong, this.userLatLong})
      : super(key: key);

  final LatLng? driverLatLong;
  final LatLng? userLatLong;

  @override
  State<TrackLocationScreen> createState() => _TrackLocationScreenState();
}

class _TrackLocationScreenState extends State<TrackLocationScreen> {
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  final List<MarkerData> customMarkers = [];

  LatLng? initialPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialPosition = LatLng(widget.driverLatLong?.latitude ?? 22.7196,
    //     widget.driverLatLong?.longitude ?? 75.8577);
    initialPosition = LatLng(widget.driverLatLong?.latitude ?? 22.7196,
        widget.driverLatLong?.longitude ?? 75.8577);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                CustomGoogleMapMarkerBuilder(
                  customMarkers: customMarkers,
                  builder: (p0, markers) {
                    return GoogleMap(
                      onMapCreated: (controller) async {
                        mapController = controller;
                        await getPollyLines();

                        await setmarker();

                        // controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                        //   target: initialPosition!,
                        //   zoom: 12.0,
                        //   //bearing: bearing,
                        // )));
                      },
                      initialCameraPosition: CameraPosition(
                        target: initialPosition!,
                        zoom: 12.0,
                      ),
                      markers: Set<Marker>.of(markers ?? []),
                      polylines: Set<Polyline>.of(polylines.values),
                    );
                  },
                ),
                Positioned(
                  bottom: 40.0,
                  right: 55.0,
                  left: 55.0,
                  child: ElevatedButton(
                    onPressed: () {
                      String lat = "${widget.userLatLong?.latitude}" ??
                          ''; //'22.7177'; //
                      String lon = "${widget.userLatLong?.longitude}" ??
                          ''; //'75.8545'; //
                      String CURENT_LAT = '${widget.driverLatLong?.latitude}';
                      String CURENT_LONG = '${widget.driverLatLong?.longitude}';

                      final Uri url = Uri.parse(
                          'https://www.google.com/maps/dir/?api=1&origin=' +
                              CURENT_LAT +
                              ',' +
                              CURENT_LONG +
                              ' &destination=' +
                              lat.toString() +
                              ',' +
                              lon.toString() +
                              '&travelmode=driving&dir_action=navigate');

                      _launchURL(
                        url,
                      );
                      // Add tracking location logic
                    },
                    style: ElevatedButton.styleFrom(
                      primary: CustomColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Live Track Location'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPollyLines() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConstants.mapKey,
      PointLatLng(widget.driverLatLong?.latitude ?? 0.0,
          widget.driverLatLong?.longitude ?? 0.0),
      PointLatLng(widget.userLatLong?.latitude ?? 0.0,
          widget.userLatLong?.longitude ?? 0.0),
      travelMode: TravelMode.driving,
    );

    print("POLYLINE--------${result.status}");
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 5,
      color: CustomColors.primaryColor,
    );
    polylines[id] = polyline;

    setState(() {});
  }

  setmarker() {
    customMarkers.add(MarkerData(
      marker: Marker(
          markerId: const MarkerId('id-0'),
          position: widget.driverLatLong ?? LatLng(0.0, 0.0)),
      child:
          Image.asset('assets/images/drivermarker.png', height: 50, width: 50),
    ));
    customMarkers.add(MarkerData(
      marker: Marker(
          markerId: const MarkerId('id-1'),
          position: widget.userLatLong ?? LatLng(0.0, 0.0)),
      child: Image.asset('assets/images/usermarker.png', height: 40, width: 40),
    ));

    LatLngBounds? bounds;
    if (mapController != null) {
      bounds = LatLngBounds(
        southwest: initialPosition!,
        northeast: LatLng(widget.userLatLong?.latitude ?? 22.7533,
            widget.userLatLong?.longitude ?? 75.8937),
      );
    }

    LatLng centerBounds = LatLng(
      (bounds!.northeast.longitude + bounds.southwest.longitude) / 2,
      (bounds!.northeast.latitude + bounds.southwest.latitude) / 2,
    );

    zoomToFit(mapController, bounds, centerBounds, 0.0);
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds,
      LatLng centerBounds, double bearing,
      {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if (fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        print('${centerBounds.latitude}_________${centerBounds.longitude}_');


        if(centerBounds.latitude > 50){

          centerBounds = LatLng(centerBounds.longitude, centerBounds.latitude);

        }


        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
          //bearing: bearing,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  void _launchURL(Uri url) async {
    // isNetworkAvail = await isNetworkAvailable();
    print("url ....$url");
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      //await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: getTranslated(context, "Could not launch "),
        //  'Could not launch '
      );
      throw 'Could not launch $url';
    }
  }
}
